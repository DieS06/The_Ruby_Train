# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurgeSuspendedUsersJob, type: :job do
  describe '#perform' do
    let!(:recent_suspended_user) { create(:user, state: 'suspended', updated_at: 15.days.ago) }
    let!(:old_suspended_user) { create(:user, state: 'suspended', updated_at: 45.days.ago) }
    let!(:very_old_suspended_user) { create(:user, state: 'suspended', updated_at: 60.days.ago) }
    let!(:active_user) { create(:user, state: 'confirmed', updated_at: 45.days.ago) }
    let!(:old_active_user) { create(:user, state: 'confirmed', updated_at: 60.days.ago) }

    before do
      # Mock the suspended scope
      allow(User).to receive(:suspended).and_return(
        User.where(state: 'suspended')
      )
    end

    it 'deletes suspended users updated more than 30 days ago' do
      expect {
        described_class.perform_now
      }.to change { User.where(id: [ old_suspended_user.id, very_old_suspended_user.id ]).count }.from(2).to(0)
    end

    it 'preserves recently suspended users (within 30 days)' do
      described_class.perform_now

      expect(User.find_by(id: recent_suspended_user.id)).to be_present
    end

    it 'preserves active users regardless of update time' do
      described_class.perform_now

      expect(User.find_by(id: active_user.id)).to be_present
      expect(User.find_by(id: old_active_user.id)).to be_present
    end

    it 'only considers suspended users' do
      expect(User).to receive(:suspended).and_call_original

      described_class.perform_now
    end

    it 'uses the correct threshold (30 days ago)' do
      freeze_time do
        threshold = 30.days.ago
        scope_double = double('suspended_scope')

        allow(User).to receive(:suspended).and_return(scope_double)
        allow(scope_double).to receive(:where).with("updated_at < ?", threshold).and_return([])
        allow([]).to receive(:find_each)

        described_class.perform_now

        expect(scope_double).to have_received(:where).with("updated_at < ?", threshold)
      end
    end

    it 'processes users in batches using find_each' do
      users_relation = User.suspended.where("updated_at < ?", 30.days.ago)
      allow(User.suspended).to receive(:where).and_return(users_relation)
      expect(users_relation).to receive(:find_each).and_yield(old_suspended_user).and_yield(very_old_suspended_user)

      described_class.perform_now
    end

    it 'calls destroy! on each eligible user' do
      allow(old_suspended_user).to receive(:destroy!)
      allow(very_old_suspended_user).to receive(:destroy!)

      # Mock the query chain
      relation = double('relation')
      allow(User).to receive(:suspended).and_return(relation)
      allow(relation).to receive(:where).and_return([ old_suspended_user, very_old_suspended_user ])
      allow([ old_suspended_user, very_old_suspended_user ]).to receive(:find_each).and_yield(old_suspended_user).and_yield(very_old_suspended_user)

      described_class.perform_now

      expect(old_suspended_user).to have_received(:destroy!)
      expect(very_old_suspended_user).to have_received(:destroy!)
    end

    context 'when no suspended users exist' do
      before do
        User.where(state: 'suspended').destroy_all
      end

      it 'completes without errors' do
        expect { described_class.perform_now }.not_to raise_error
      end
    end

    context 'when user destruction fails' do
      before do
        allow(old_suspended_user).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)

        # Mock the query to return only the problematic user
        relation = double('relation')
        allow(User).to receive(:suspended).and_return(relation)
        allow(relation).to receive(:where).and_return([ old_suspended_user ])
        allow([ old_suspended_user ]).to receive(:find_each).and_yield(old_suspended_user)
      end

      it 'raises the exception' do
        expect {
          described_class.perform_now
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end

    describe 'edge cases' do
      it 'handles users updated exactly 30 days ago' do
        exactly_30_days_user = create(:user, state: 'suspended', updated_at: 30.days.ago)

        described_class.perform_now

        # User updated exactly 30 days ago should be preserved
        expect(User.find_by(id: exactly_30_days_user.id)).to be_present
      end

      it 'handles users updated just over 30 days ago' do
        just_over_30_days_user = create(:user, state: 'suspended', updated_at: 30.days.ago - 1.minute)

        expect {
          described_class.perform_now
        }.to change { User.exists?(just_over_30_days_user.id) }.from(true).to(false)
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

  describe 'integration test' do
    let!(:users_to_purge) do
      [
        create(:user, state: 'suspended', updated_at: 35.days.ago),
        create(:user, state: 'suspended', updated_at: 50.days.ago)
      ]
    end

    let!(:users_to_keep) do
      [
        create(:user, state: 'suspended', updated_at: 20.days.ago),
        create(:user, state: 'confirmed', updated_at: 50.days.ago)
      ]
    end

    it 'performs the purge operation correctly' do
      initial_count = User.count

      described_class.perform_now

      expect(User.count).to eq(initial_count - 2)

      users_to_purge.each do |user|
        expect(User.exists?(user.id)).to be false
      end

      users_to_keep.each do |user|
        expect(User.exists?(user.id)).to be true
      end
    end
  end
end
