# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:token) { 'valid_token_123' }
  
  describe "GET /groups/accept/:token" do
    context "with valid token and pending membership" do
      let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'invited') }
      
      it "returns http success" do
        get "/groups/accept/#{token}"
        expect(response).to have_http_status(:success)
      end
      
      it "returns JSON response" do
        get "/groups/accept/#{token}"
        expect(response.content_type).to include('application/json')
      end
      
      it "updates membership to joined" do
        expect {
          get "/groups/accept/#{token}"
        }.to change { membership.reload.state }.from('invited').to('joined')
      end
      
      it "sets joined_at timestamp" do
        freeze_time do
          get "/groups/accept/#{token}"
          expect(membership.reload.joined_at).to be_within(1.second).of(Time.current)
        end
      end
      
      it "clears the invitation token" do
        get "/groups/accept/#{token}"
        expect(membership.reload.invited_token).to be_nil
      end
      
      it "returns welcome message with group and user info" do
        get "/groups/accept/#{token}"
        
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Welcome to the group!')
        expect(json_response['group']).to eq(group.name)
        expect(json_response['user']).to eq(user.email)
      end
    end
    
    context "with invalid token" do
      it "returns not found status" do
        get "/groups/accept/invalid_token"
        expect(response).to have_http_status(:not_found)
      end
      
      it "returns error message" do
        get "/groups/accept/invalid_token"
        
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid invitation token')
      end
    end
    
    context "with already joined membership" do
      let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'joined') }
      
      it "returns ok status" do
        get "/groups/accept/#{token}"
        expect(response).to have_http_status(:ok)
      end
      
      it "returns already joined message" do
        get "/groups/accept/#{token}"
        
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Already joined')
      end
      
      it "does not change the membership state" do
        expect {
          get "/groups/accept/#{token}"
        }.not_to change { membership.reload.state }
      end
    end
    
    context "with different membership states" do
      context "when membership is pending" do
        let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'pending') }
        
        it "accepts the invitation" do
          get "/groups/accept/#{token}"
          expect(response).to have_http_status(:success)
          expect(membership.reload.state).to eq('joined')
        end
      end
      
      context "when membership is rejected" do
        let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'rejected') }
        
        it "accepts the invitation (allows re-joining)" do
          get "/groups/accept/#{token}"
          expect(response).to have_http_status(:success)
          expect(membership.reload.state).to eq('joined')
        end
      end
      
      context "when membership is removed" do
        let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'removed') }
        
        it "accepts the invitation (allows re-joining)" do
          get "/groups/accept/#{token}"
          expect(response).to have_http_status(:success)
          expect(membership.reload.state).to eq('joined')
        end
      end
    end
    
    context "with expired token" do
      let!(:membership) { create(:group_membership, user: user, group: group, invited_token: nil, state: 'invited') }
      
      it "returns not found for cleared token" do
        get "/groups/accept/#{token}"
        expect(response).to have_http_status(:not_found)
      end
    end
    
    context "error handling" do
      let!(:membership) { create(:group_membership, user: user, group: group, invited_token: token, state: 'invited') }
      
      context "when update fails" do
        before do
          allow_any_instance_of(GroupMembership).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        end
        
        it "raises the validation error" do
          expect {
            get "/groups/accept/#{token}"
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      
      context "when database constraint fails" do
        before do
          allow_any_instance_of(GroupMembership).to receive(:update!).and_raise(ActiveRecord::RecordNotSaved)
        end
        
        it "raises the database error" do
          expect {
            get "/groups/accept/#{token}"
          }.to raise_error(ActiveRecord::RecordNotSaved)
        end
      end
    end
    
    context "integration scenarios" do
      let(:inviter) { create(:user) }
      let!(:membership) do
        create(:group_membership, 
               user: user, 
               group: group, 
               invited_token: token, 
               state: 'invited',
               invited_by: inviter.id)
      end
      
      it "completes the invitation workflow" do
        # Simulate the full flow: invitation -> acceptance
        expect(membership.state).to eq('invited')
        expect(membership.invited_token).to eq(token)
        expect(membership.joined_at).to be_nil
        
        get "/groups/accept/#{token}"
        
        membership.reload
        expect(membership.state).to eq('joined')
        expect(membership.invited_token).to be_nil
        expect(membership.joined_at).to be_present
        expect(membership.invited_by).to eq(inviter.id) # preserves inviter
      end
    end
    
    context "with multiple memberships" do
      let(:other_group) { create(:group) }
      let(:other_token) { 'other_token_456' }
      let!(:membership1) { create(:group_membership, user: user, group: group, invited_token: token, state: 'invited') }
      let!(:membership2) { create(:group_membership, user: user, group: other_group, invited_token: other_token, state: 'invited') }
      
      it "only affects the specific membership" do
        get "/groups/accept/#{token}"
        
        expect(membership1.reload.state).to eq('joined')
        expect(membership2.reload.state).to eq('invited') # unchanged
      end
    end
  end
  
  describe "private methods" do
    let(:controller_instance) { GroupsController.new }
    
    describe "#find_membership_by_token" do
      let!(:membership) { create(:group_membership, invited_token: token) }
      
      it "finds membership by token" do
        allow(controller_instance).to receive(:params).and_return({ token: token })
        controller_instance.send(:find_membership_by_token)
        
        expect(controller_instance.instance_variable_get(:@membership)).to eq(membership)
      end
      
      it "sets nil when token not found" do
        allow(controller_instance).to receive(:params).and_return({ token: 'nonexistent' })
        controller_instance.send(:find_membership_by_token)
        
        expect(controller_instance.instance_variable_get(:@membership)).to be_nil
      end
    end
  end
end