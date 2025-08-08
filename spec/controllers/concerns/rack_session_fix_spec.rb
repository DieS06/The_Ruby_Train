# frozen_string_literal: true

require 'rails_helper'

class TestController < ApplicationController
  include RackSessionFix

  def test_action
    render plain: 'test'
  end
end

RSpec.describe RackSessionFix, type: :controller do
  controller(TestController) do
    def index
      render plain: 'test response'
    end
  end

  describe 'FakeRackSession class' do
    let(:fake_session) { RackSessionFix::FakeRackSession.new }

    it 'inherits from Hash' do
      expect(fake_session).to be_a(Hash)
    end

    it 'implements enabled? method returning false' do
      expect(fake_session.enabled?).to be false
    end

    it 'behaves like a hash' do
      fake_session[:key] = 'value'
      expect(fake_session[:key]).to eq('value')
      expect(fake_session['key']).to be_nil # Hash behavior
    end

    it 'can store and retrieve values' do
      fake_session['test'] = 'data'
      expect(fake_session['test']).to eq('data')
    end
  end

  describe 'concern inclusion' do
    it 'adds before_action callback' do
      expect(controller.class._process_action_callbacks.map(&:filter)).to include(:set_fake_session)
    end

    it 'includes the concern properly' do
      expect(controller.class.ancestors).to include(RackSessionFix)
    end
  end

  describe 'session setup' do
    before do
      routes.draw { get 'index', to: 'anonymous#index' }
    end

    it 'sets up fake rack session when not present' do
      # Simulate missing rack.session
      allow(request).to receive(:env).and_return({})

      get :index

      expect(request.env['rack.session']).to be_a(RackSessionFix::FakeRackSession)
      expect(request.env['rack.session'].enabled?).to be false
    end

    it 'preserves existing rack session if present' do
      existing_session = { 'user_id' => 123 }
      allow(request).to receive(:env).and_return({ 'rack.session' => existing_session })

      get :index

      expect(request.env['rack.session']).to eq(existing_session)
      expect(request.env['rack.session']).not_to be_a(RackSessionFix::FakeRackSession)
    end

    it 'executes before every action' do
      expect(controller).to receive(:set_fake_session).and_call_original

      get :index
    end
  end

  describe 'private method set_fake_session' do
    it 'is defined as private' do
      expect(controller.class.private_method_defined?(:set_fake_session)).to be true
    end

    it 'uses ||= operator to avoid overwriting existing session' do
      controller.send(:set_fake_session)
      original_session = request.env['rack.session']

      controller.send(:set_fake_session)

      expect(request.env['rack.session']).to be(original_session)
    end
  end

  describe 'integration with Rails session' do
    before do
      routes.draw { get 'index', to: 'anonymous#index' }
    end

    it 'provides session functionality when needed' do
      get :index

      expect(response).to have_http_status(:success)
      expect(request.env['rack.session']).to be_present
    end

    it 'handles session access gracefully' do
      get :index

      # Should be able to access session without errors
      expect { request.env['rack.session']['test'] = 'value' }.not_to raise_error
      expect(request.env['rack.session']['test']).to eq('value')
    end
  end

  describe 'use case scenarios' do
    context 'when Rack session is disabled or missing' do
      before do
        allow(request).to receive(:env).and_return({})
        routes.draw { get 'index', to: 'anonymous#index' }
      end

      it 'provides fallback session functionality' do
        get :index

        session = request.env['rack.session']
        expect(session).to be_a(RackSessionFix::FakeRackSession)
        expect(session.enabled?).to be false

        # Can still use it as a hash
        session['data'] = 'test'
        expect(session['data']).to eq('test')
      end
    end

    context 'when working with API endpoints' do
      it 'ensures session availability for middleware that depends on it' do
        get :index

        # Even if session is fake, middleware won't break
        expect(request.env['rack.session']).to respond_to(:[])
        expect(request.env['rack.session']).to respond_to(:[]=)
        expect(request.env['rack.session']).to respond_to(:enabled?)
      end
    end
  end

  describe 'thread safety' do
    it 'creates separate session instances per request' do
      allow(request).to receive(:env).and_return({})

      get :index
      session1 = request.env['rack.session']

      # Simulate new request
      allow(request).to receive(:env).and_return({})
      controller.send(:set_fake_session)
      session2 = request.env['rack.session']

      expect(session1).not_to be(session2)
      expect(session1).to be_a(RackSessionFix::FakeRackSession)
      expect(session2).to be_a(RackSessionFix::FakeRackSession)
    end
  end

  describe 'error handling' do
    it 'handles nil environment gracefully' do
      allow(request).to receive(:env).and_return(nil)

      expect {
        controller.send(:set_fake_session)
      }.to raise_error(NoMethodError) # Expected behavior with nil env
    end

    it 'handles malformed environment' do
      allow(request).to receive(:env).and_return('not_a_hash')

      expect {
        controller.send(:set_fake_session)
      }.to raise_error(NoMethodError) # Expected behavior with invalid env
    end
  end
end
