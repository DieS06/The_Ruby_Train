# frozen_string_literal: true

require 'rails_helper'

class TestMembershipModel < ActiveRecord::Base
  self.table_name = 'group_memberships'
  include StateMembership
end

RSpec.describe StateMembership, type: :concern do
  let(:membership) { TestMembershipModel.create!(user_id: 1, group_id: 1, role_in_group: 'student') }
  
  describe 'enum states' do
    it 'defines the correct enum values' do
      expect(TestMembershipModel.states).to eq({
        'pending' => 0,
        'invited' => 1,
        'joined' => 2,
        'rejected' => 3,
        'removed' => 4
      })
    end
    
    it 'defaults to pending state' do
      expect(membership.state).to eq('pending')
    end
  end
  
  describe 'validations' do
    it 'validates presence of state' do
      membership = TestMembershipModel.new(user_id: 1, group_id: 1, role_in_group: 'student', state: nil)
      expect(membership).not_to be_valid
      expect(membership.errors[:state]).to include("can't be blank")
    end
  end
  
  describe 'scopes' do
    let!(:pending_membership) { TestMembershipModel.create!(user_id: 1, group_id: 1, role_in_group: 'student', state: 'pending') }
    let!(:invited_membership) { TestMembershipModel.create!(user_id: 2, group_id: 1, role_in_group: 'student', state: 'invited') }
    let!(:joined_membership) { TestMembershipModel.create!(user_id: 3, group_id: 1, role_in_group: 'student', state: 'joined') }
    let!(:rejected_membership) { TestMembershipModel.create!(user_id: 4, group_id: 1, role_in_group: 'student', state: 'rejected') }
    let!(:removed_membership) { TestMembershipModel.create!(user_id: 5, group_id: 1, role_in_group: 'student', state: 'removed') }
    
    it 'filters by pending state' do
      expect(TestMembershipModel.pending).to include(pending_membership)
      expect(TestMembershipModel.pending).not_to include(invited_membership)
    end
    
    it 'filters by invited state' do
      expect(TestMembershipModel.invited).to include(invited_membership)
      expect(TestMembershipModel.invited).not_to include(pending_membership)
    end
    
    it 'filters by joined state' do
      expect(TestMembershipModel.joined).to include(joined_membership)
      expect(TestMembershipModel.joined).not_to include(invited_membership)
    end
    
    it 'filters by rejected state' do
      expect(TestMembershipModel.rejected).to include(rejected_membership)
      expect(TestMembershipModel.rejected).not_to include(joined_membership)
    end
    
    it 'filters by removed state' do
      expect(TestMembershipModel.removed).to include(removed_membership)
      expect(TestMembershipModel.removed).not_to include(joined_membership)
    end
  end
  
  describe 'state predicate methods' do
    it 'correctly identifies pending state' do
      membership.update!(state: 'pending')
      expect(membership).to be_pending
      expect(membership).not_to be_invited
    end
    
    it 'correctly identifies invited state' do
      membership.update!(state: 'invited')
      expect(membership).to be_invited
      expect(membership).not_to be_pending
    end
    
    it 'correctly identifies joined state' do
      membership.update!(state: 'joined')
      expect(membership).to be_joined
      expect(membership).not_to be_invited
    end
    
    it 'correctly identifies rejected state' do
      membership.update!(state: 'rejected')
      expect(membership).to be_rejected
      expect(membership).not_to be_joined
    end
    
    it 'correctly identifies removed state' do
      membership.update!(state: 'removed')
      expect(membership).to be_removed
      expect(membership).not_to be_joined
    end
  end
  
  describe 'membership workflow' do
    it 'can transition from pending to invited' do
      membership.update!(state: 'pending')
      membership.update!(state: 'invited')
      expect(membership).to be_invited
    end
    
    it 'can transition from invited to joined' do
      membership.update!(state: 'invited')
      membership.update!(state: 'joined')
      expect(membership).to be_joined
    end
    
    it 'can transition from invited to rejected' do
      membership.update!(state: 'invited')
      membership.update!(state: 'rejected')
      expect(membership).to be_rejected
    end
    
    it 'can transition from joined to removed' do
      membership.update!(state: 'joined')
      membership.update!(state: 'removed')
      expect(membership).to be_removed
    end
  end
  
  describe 'integration with actual models' do
    it 'works with GroupMembership model' do
      group_membership = create(:group_membership)
      expect(group_membership).to respond_to(:pending?)
      expect(group_membership).to respond_to(:invited?)
      expect(group_membership).to respond_to(:joined?)
      expect(group_membership).to respond_to(:rejected?)
      expect(group_membership).to respond_to(:removed?)
    end
  end
end