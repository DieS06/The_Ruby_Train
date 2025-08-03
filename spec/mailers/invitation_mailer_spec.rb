# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  describe '#custom_invite' do
    let(:inviter) { create(:user, first_name: 'John', last_name: 'Doe') }
    let(:user) { create(:user, email: 'invited@example.com') }
    let(:message) { 'Welcome to our platform!' }
    
    context 'without group' do
      let(:mail) { described_class.custom_invite(user, inviter, message) }
      
      before do
        allow(user).to receive(:raw_invitation_token).and_return('invitation_token_123')
      end
      
      it 'renders the headers' do
        expect(mail.to).to eq([user.email])
      end
      
      it 'includes the inviter in the email body' do
        expect(mail.body.encoded).to include(inviter.first_name)
      end
      
      it 'includes the custom message in the email body' do
        expect(mail.body.encoded).to include(message)
      end
      
      it 'includes the invitation URL' do
        expect(mail.body.encoded).to include('invitation_token_123')
      end
      
      it 'queues the email for delivery' do
        expect(mail.delivery_job).to eq(ActionMailer::MailDeliveryJob)
      end
    end
    
    context 'with group' do
      let(:group) { create(:group, name: 'Test Group') }
      let(:group_membership) { create(:group_membership, user: user, group: group, invited_token: 'group_token_123') }
      let(:mail) { described_class.custom_invite(user, inviter, message, group: group) }
      
      before do
        group_membership
        allow(user.group_memberships).to receive(:find_by).with(group: group).and_return(group_membership)
      end
      
      it 'renders the headers for group invitation' do
        expect(mail.to).to eq([user.email])
      end
      
      it 'includes the group information in the email body' do
        expect(mail.body.encoded).to include(group.name)
      end
      
      it 'includes the custom message in the email body' do
        expect(mail.body.encoded).to include(message)
      end
      
      it 'includes the group invitation URL' do
        expect(mail.body.encoded).to include('group_token_123')
      end
    end
    
    context 'with empty message' do
      let(:mail) { described_class.custom_invite(user, inviter, '') }
      
      it 'uses default message when message is empty' do
        expect(mail.body.encoded).to include('join our learning community')
      end
    end
    
    context 'with nil message' do
      let(:mail) { described_class.custom_invite(user, inviter, nil) }
      
      it 'uses default message when message is nil' do
        expect(mail.body.encoded).to include('join our learning community')
      end
    end
    
    describe 'email formatting' do
      let(:mail) { described_class.custom_invite(user, inviter, message) }
      
      it 'renders both text and html versions' do
        expect(mail.text_part).to be_present
        expect(mail.html_part).to be_present
      end
    end
    
    describe 'delivery configuration' do
      let(:mail) { described_class.custom_invite(user, inviter, message) }
      
      it 'schedules delivery on mailers queue' do
        expect(mail.delivery_job.queue_name).to eq('mailers')
      end
    end
    
    describe 'error handling' do
      context 'when group membership is not found' do
        let(:group) { create(:group) }
        let(:mail) { described_class.custom_invite(user, inviter, message, group: group) }
        
        before do
          allow(user.group_memberships).to receive(:find_by).with(group: group).and_return(nil)
        end
        
        it 'handles missing group membership gracefully' do
          expect { mail }.not_to raise_error
        end
      end
    end
  end
end
