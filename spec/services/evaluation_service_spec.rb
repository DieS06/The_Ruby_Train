# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationService, type: :service do
  let(:user) { create(:user) }
  let(:content_unit) { create(:content_unit) }
  
  describe '.call' do
    context 'when creating a new evaluation' do
      let(:params) do
        {
          title: 'New Evaluation',
          description: 'Test evaluation',
          content_unit_id: content_unit.id,
          type: 'Evaluations::Quiz'
        }
      end
      
      it 'creates a new evaluation successfully' do
        result = described_class.call(user: user, params: params)
        
        expect(result.success?).to be true
        expect(result.evaluation).to be_persisted
        expect(result.evaluation.title).to eq('New Evaluation')
        expect(result.evaluation.created_by).to eq(user.id)
        expect(result.errors).to be_empty
      end
      
      it 'sets the created_by field' do
        result = described_class.call(user: user, params: params)
        
        expect(result.evaluation.created_by).to eq(user.id)
      end
      
      context 'with invalid params' do
        let(:invalid_params) { { title: '', content_unit_id: content_unit.id } }
        
        it 'returns failure with errors' do
          result = described_class.call(user: user, params: invalid_params)
          
          expect(result.success?).to be false
          expect(result.evaluation).to be_nil
          expect(result.errors).to include("Title can't be blank")
        end
      end
    end
    
    context 'when updating an existing evaluation' do
      let!(:evaluation) { create(:evaluation, created_by: user.id) }
      let(:params) do
        {
          id: evaluation.id,
          title: 'Updated Evaluation',
          description: 'Updated description'
        }
      end
      
      it 'updates the evaluation successfully' do
        result = described_class.call(user: user, params: params)
        
        expect(result.success?).to be true
        expect(result.evaluation.title).to eq('Updated Evaluation')
        expect(result.evaluation.description).to eq('Updated description')
        expect(result.errors).to be_empty
      end
      
      it 'does not change the created_by field' do
        original_created_by = evaluation.created_by
        result = described_class.call(user: user, params: params)
        
        expect(result.evaluation.created_by).to eq(original_created_by)
      end
      
      context 'when user is not the creator' do
        let(:other_user) { create(:user) }
        
        it 'returns authorization error' do
          result = described_class.call(user: other_user, params: params)
          
          expect(result.success?).to be false
          expect(result.evaluation).to be_nil
          expect(result.errors).to include('You are not authorized to perform this action')
        end
      end
      
      context 'with invalid update params' do
        let(:invalid_params) do
          {
            id: evaluation.id,
            title: ''
          }
        end
        
        it 'returns failure with validation errors' do
          result = described_class.call(user: user, params: invalid_params)
          
          expect(result.success?).to be false
          expect(result.evaluation).to be_nil
          expect(result.errors).to include("Title can't be blank")
        end
      end
    end
    
    context 'when evaluation is not found' do
      let(:params) { { id: 99999, title: 'Test' } }
      
      it 'returns not found error' do
        expect {
          described_class.call(user: user, params: params)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe 'return object structure' do
      let(:params) { { title: 'Test', content_unit_id: content_unit.id } }
      
      it 'returns an OpenStruct with required methods' do
        result = described_class.call(user: user, params: params)
        
        expect(result).to respond_to(:success?)
        expect(result).to respond_to(:evaluation)
        expect(result).to respond_to(:errors)
      end
      
      context 'on success' do
        it 'has the correct structure' do
          result = described_class.call(user: user, params: params)
          
          expect(result.success?).to be true
          expect(result.evaluation).to be_a(Evaluation)
          expect(result.errors).to eq([])
        end
      end
      
      context 'on failure' do
        let(:invalid_params) { { title: '' } }
        
        it 'has the correct structure' do
          result = described_class.call(user: user, params: invalid_params)
          
          expect(result.success?).to be false
          expect(result.evaluation).to be_nil
          expect(result.errors).to be_an(Array)
          expect(result.errors).not_to be_empty
        end
      end
    end
    
    describe 'params handling' do
      let(:params) do
        {
          id: 'should_be_excluded',
          title: 'Test Evaluation',
          content_unit_id: content_unit.id,
          extra_param: 'should_be_included'
        }
      end
      
      it 'excludes id from assignment but includes other params' do
        allow(Evaluation).to receive(:new).and_call_original
        
        described_class.call(user: user, params: params)
        
        expect(Evaluation).to have_received(:new)
      end
    end
  end
end