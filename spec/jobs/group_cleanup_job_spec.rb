# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupCleanupJob, type: :job do
  describe '#perform' do
    let!(:regular_group) { create(:group, state: 'active') }
    let!(:expired_group1) { create(:group) }
    let!(:expired_group2) { create(:group) }
    
    before do
      # Mock the expired_deletions scope to return specific groups
      allow(Group).to receive(:expired_deletions).and_return([expired_group1, expired_group2])
    end
    
    it 'destroys expired groups' do
      expect {
        described_class.perform_now
      }.to change { Group.where(id: [expired_group1.id, expired_group2.id]).count }.from(2).to(0)
    end
    
    it 'preserves non-expired groups' do
      described_class.perform_now
      
      expect(Group.find_by(id: regular_group.id)).to be_present
    end
    
    it 'calls expired_deletions scope' do
      described_class.perform_now
      
      expect(Group).to have_received(:expired_deletions)
    end
    
    it 'processes groups in batches using find_each' do
      expect([expired_group1, expired_group2]).to receive(:find_each).and_yield(expired_group1).and_yield(expired_group2)
      
      described_class.perform_now
    end
    
    it 'calls destroy! on each expired group' do
      allow(expired_group1).to receive(:destroy!)
      allow(expired_group2).to receive(:destroy!)
      
      allow([expired_group1, expired_group2]).to receive(:find_each).and_yield(expired_group1).and_yield(expired_group2)
      
      described_class.perform_now
      
      expect(expired_group1).to have_received(:destroy!)
      expect(expired_group2).to have_received(:destroy!)
    end
    
    context 'when no expired groups exist' do
      before do
        allow(Group).to receive(:expired_deletions).and_return([])
      end
      
      it 'completes without errors' do
        expect { described_class.perform_now }.not_to raise_error
      end
    end
    
    context 'when group destruction fails' do
      before do
        allow(expired_group1).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
        allow(Group).to receive(:expired_deletions).and_return([expired_group1])
        allow([expired_group1]).to receive(:find_each).and_yield(expired_group1)
      end
      
      it 'raises the exception' do
        expect {
          described_class.perform_now
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
    
    describe 'with group dependencies' do
      let!(:group_with_members) { create(:group) }
      let!(:group_membership) { create(:group_membership, group: group_with_members) }
      let!(:group_course) { create(:group_course, group: group_with_members) }
      
      before do
        allow(Group).to receive(:expired_deletions).and_return([group_with_members])
        allow([group_with_members]).to receive(:find_each).and_yield(group_with_members)
      end
      
      it 'destroys groups with associated data' do
        expect {
          described_class.perform_now
        }.to change { Group.exists?(group_with_members.id) }.from(true).to(false)
      end
    end
    
    describe 'with different group states' do
      let!(:archived_expired_group) { create(:group, state: 'archived') }
      let!(:closed_expired_group) { create(:group, state: 'closed') }
      
      before do
        allow(Group).to receive(:expired_deletions).and_return([archived_expired_group, closed_expired_group])
        allow([archived_expired_group, closed_expired_group]).to receive(:find_each).and_yield(archived_expired_group).and_yield(closed_expired_group)
      end
      
      it 'cleans up groups regardless of state' do
        expect {
          described_class.perform_now
        }.to change { Group.where(id: [archived_expired_group.id, closed_expired_group.id]).count }.from(2).to(0)
      end
    end
  end
  
  describe 'job configuration' do
    it 'is queued on default queue' do
      expect(described_class.queue_name).to eq('default')
    end
    
    it 'inherits from ApplicationJob' do
      expect(described_class.superclass).to eq(ApplicationJob)
    end
  end
  
  describe 'integration with Group model' do
    context 'when expired_deletions scope exists' do
      it 'relies on Group model to define expired groups' do
        # This test ensures the job correctly delegates to the model
        expect(Group).to respond_to(:expired_deletions)
      end
    end
  end
  
  describe 'error handling scenarios' do
    context 'when database is locked' do
      before do
        allow(Group).to receive(:expired_deletions).and_raise(ActiveRecord::StatementInvalid.new('database is locked'))
      end
      
      it 'raises the database error' do
        expect {
          described_class.perform_now
        }.to raise_error(ActiveRecord::StatementInvalid, /database is locked/)
      end
    end
    
    context 'when Group model is not available' do
      before do
        allow(Group).to receive(:expired_deletions).and_raise(NameError.new('uninitialized constant Group'))
      end
      
      it 'raises the name error' do
        expect {
          described_class.perform_now
        }.to raise_error(NameError, /uninitialized constant Group/)
      end
    end
  end
  
  describe 'integration test' do
    let!(:groups_to_cleanup) { create_list(:group, 2) }
    let!(:groups_to_keep) { create_list(:group, 2) }
    
    before do
      allow(Group).to receive(:expired_deletions).and_return(groups_to_cleanup)
    end
    
    it 'performs the cleanup operation correctly' do
      initial_count = Group.count
      
      described_class.perform_now
      
      expect(Group.count).to eq(initial_count - 2)
      
      groups_to_cleanup.each do |group|
        expect(Group.exists?(group.id)).to be false
      end
      
      groups_to_keep.each do |group|
        expect(Group.exists?(group.id)).to be true
      end
    end
  end
end