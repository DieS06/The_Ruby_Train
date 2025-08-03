# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InviteUserService, type: :service do
  let(:inviter) { create(:user).tap { |u| u.add_role(:admin) } }
  let(:email) { 'new@example.com' }
  let(:first_name) { 'John' }
  let(:last_name) { 'Doe' }
  let(:message) { 'Welcome to our platform!' }
  
  before do
    allow(InvitationMailer).to receive(:custom_invite).and_return(double(deliver_later: true))
    allow(Rails.logger).to receive(:info)
  end
  
  describe '.call' do
    context 'when inviter has permission' do
      it 'invites a new user successfully' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          message: message
        )
        
        expect(result).to be_a(User)
        expect(result.email).to eq(email)
        expect(result.first_name).to eq(first_name)
        expect(result.last_name).to eq(last_name)
      end
      
      it 'creates a profile for the new user' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(result.profile).to be_present
      end
      
      it 'sends invitation email' do
        described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          message: message
        )
        
        expect(InvitationMailer).to have_received(:custom_invite)
      end
      
      it 'logs the invitation' do
        described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(Rails.logger).to have_received(:info).with(/invited/)
      end
    end
    
    context 'when inviter does not have permission' do
      let(:unauthorized_user) { create(:user) }
      
      it 'raises CanCan::AccessDenied' do
        expect {
          described_class.call(
            inviter: unauthorized_user,
            email: email,
            first_name: first_name,
            last_name: last_name
          )
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    context 'when user already exists' do
      let!(:existing_user) { create(:user, email: email) }
      
      it 'finds and returns the existing user' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(result).to eq(existing_user)
      end
      
      it 'creates profile if user does not have one' do
        existing_user.profile&.destroy
        
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(result.profile).to be_present
      end
      
      it 'does not create profile if user already has one' do
        original_profile = existing_user.profile
        
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(result.profile).to eq(original_profile)
      end
    end
    
    context 'with global role assignment' do
      let(:role) { :student }
      
      it 'assigns global role to new user' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role
        )
        
        expect(result.has_role?(role)).to be true
      end
      
      it 'does not assign role if user already has it' do
        existing_user = create(:user, email: email).tap { |u| u.add_role(role) }
        
        expect {
          described_class.call(
            inviter: inviter,
            email: email,
            first_name: first_name,
            last_name: last_name,
            role: role
          )
        }.not_to change { existing_user.roles.count }
      end
    end
    
    context 'with group invitation' do
      let(:group) { create(:group) }
      let(:role) { :student }
      
      it 'assigns scoped role to user for the group' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role,
          group: group
        )
        
        expect(result.has_role?(role, group)).to be true
      end
      
      it 'creates group membership with invited state' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role,
          group: group
        )
        
        membership = GroupMembership.find_by(user: result, group: group)
        expect(membership).to be_present
        expect(membership.state).to eq('invited')
        expect(membership.invited_by).to eq(inviter.id)
        expect(membership.invited_token).to be_present
      end
      
      it 'does not assign scoped role if user already has it' do
        existing_user = create(:user, email: email).tap { |u| u.add_role(role, group) }
        
        expect {
          described_class.call(
            inviter: inviter,
            email: email,
            first_name: first_name,
            last_name: last_name,
            role: role,
            group: group
          )
        }.not_to change { existing_user.roles.count }
      end
      
      it 'finds or creates group membership' do
        user = create(:user, email: email)
        existing_membership = create(:group_membership, user: user, group: group, state: 'pending')
        
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role,
          group: group
        )
        
        membership = GroupMembership.find_by(user: result, group: group)
        expect(membership.id).to eq(existing_membership.id)
      end
      
      it 'sends invitation email with group context' do
        described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role,
          group: group,
          message: message
        )
        
        expect(InvitationMailer).to have_received(:custom_invite).with(
          kind_of(User),
          inviter,
          message,
          group: group
        )
      end
      
      it 'logs group invitation' do
        described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name,
          role: role,
          group: group
        )
        
        expect(Rails.logger).to have_received(:info).with(/to #{group.name}/)
      end
    end
    
    context 'without optional parameters' do
      it 'works with minimal required parameters' do
        result = described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(result).to be_a(User)
        expect(result.email).to eq(email)
      end
      
      it 'sends invitation email without message and group' do
        described_class.call(
          inviter: inviter,
          email: email,
          first_name: first_name,
          last_name: last_name
        )
        
        expect(InvitationMailer).to have_received(:custom_invite).with(
          kind_of(User),
          inviter,
          nil,
          group: nil
        )
      end
    end
  end
end