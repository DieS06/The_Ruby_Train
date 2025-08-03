# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "GraphQL", type: :request do
  let(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  describe "POST /graphql" do
    context "with valid query" do
      let(:query) do
        <<~GRAPHQL
          query {
            myProfile {
              id
              user {
                email
              }
            }
          }
        GRAPHQL
      end
      
      it "returns http success" do
        post "/graphql", params: { query: query }
        expect(response).to have_http_status(:success)
      end
      
      it "returns JSON response" do
        post "/graphql", params: { query: query }
        expect(response.content_type).to include('application/json')
      end
      
      it "includes data in response" do
        user.create_profile unless user.profile
        post "/graphql", params: { query: query }
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('data')
      end
    end
    
    context "with invalid query" do
      let(:invalid_query) { "{ invalidField }" }
      
      it "returns http success with errors" do
        post "/graphql", params: { query: invalid_query }
        expect(response).to have_http_status(:success)
      end
      
      it "includes errors in response" do
        post "/graphql", params: { query: invalid_query }
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
      end
    end
    
    context "with variables" do
      let(:query) do
        <<~GRAPHQL
          query GetUser($id: ID!) {
            findUser(id: $id) {
              id
              email
            }
          }
        GRAPHQL
      end
      
      it "handles string variables" do
        variables = { id: user.id }.to_json
        post "/graphql", params: { query: query, variables: variables }
        expect(response).to have_http_status(:success)
      end
      
      it "handles hash variables" do
        variables = { id: user.id }
        post "/graphql", params: { query: query, variables: variables }
        expect(response).to have_http_status(:success)
      end
    end
    
    context "with operation name" do
      let(:query) do
        <<~GRAPHQL
          query MyProfile {
            myProfile {
              id
            }
          }
        GRAPHQL
      end
      
      it "handles operation name parameter" do
        post "/graphql", params: { 
          query: query, 
          operationName: "MyProfile" 
        }
        expect(response).to have_http_status(:success)
      end
    end
    
    context "without authentication" do
      before do
        sign_out user
      end
      
      it "redirects to login" do
        post "/graphql", params: { query: "{ myProfile { id } }" }
        expect(response).to have_http_status(:redirect)
      end
    end
    
    context "error handling" do
      before do
        allow(TheRubyTrainSchema).to receive(:execute).and_raise(StandardError.new("Test error"))
      end
      
      context "in development environment" do
        before do
          allow(Rails.env).to receive(:development?).and_return(true)
        end
        
        it "returns detailed error information" do
          post "/graphql", params: { query: "{ myProfile { id } }" }
          
          json_response = JSON.parse(response.body)
          expect(json_response['errors'][0]['message']).to eq('Test error')
          expect(json_response['errors'][0]).to have_key('backtrace')
          expect(response).to have_http_status(:internal_server_error)
        end
      end
      
      context "in production environment" do
        before do
          allow(Rails.env).to receive(:development?).and_return(false)
        end
        
        it "returns generic error message" do
          post "/graphql", params: { query: "{ myProfile { id } }" }
          
          json_response = JSON.parse(response.body)
          expect(json_response['errors'][0]['message']).to eq('Internal Server Error')
          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end
  end
  
  describe "CSRF protection" do
    it "skips CSRF token verification" do
      # This test verifies that GraphQL endpoints work without CSRF tokens
      # which is necessary for API clients
      post "/graphql", params: { query: "{ myProfile { id } }" }
      expect(response).not_to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "context setup" do
    let(:query) { "{ myProfile { id } }" }
    
    it "provides current_user in context" do
      allow(TheRubyTrainSchema).to receive(:execute) do |query, options|
        expect(options[:context][:current_user]).to eq(user)
        { data: {} }
      end
      
      post "/graphql", params: { query: query }
    end
    
    it "provides ability in context" do
      allow(TheRubyTrainSchema).to receive(:execute) do |query, options|
        expect(options[:context][:ability]).to be_a(Ability)
        { data: {} }
      end
      
      post "/graphql", params: { query: query }
    end
  end
end