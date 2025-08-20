# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BadgeAwardedNotifier, type: :notifier do
  let(:user) { create(:user) }
  let(:badge) { create(:badge, name: 'Ruby Master') }
  let(:notifier) { described_class.with(badge: badge) }
  
  describe 'configuration' do
    it 'inherits from ApplicationNotifier' do
      expect(described_class.superclass).to eq(ApplicationNotifier)
    end
    
    it 'delivers by database' do
      expect(described_class.delivery_methods).to include(:database)
    end
    
    it 'requires badge param' do
      expect(described_class.params).to include(:badge)
    end
  end
  
  describe '#message' do
    it 'includes the badge name in the message' do
      expect(notifier.message).to eq("You've earned the badge: Ruby Master")
    end
    
    context 'with different badge names' do
      let(:badge) { create(:badge, name: 'JavaScript Expert') }
      
      it 'uses the correct badge name' do
        expect(notifier.message).to eq("You've earned the badge: JavaScript Expert")
      end
    end
    
    context 'with special characters in badge name' do
      let(:badge) { create(:badge, name: 'C++ & Algorithms Pro') }
      
      it 'handles special characters' do
        expect(notifier.message).to eq("You've earned the badge: C++ & Algorithms Pro")
      end
    end
  end
  
  describe '#url' do
    it 'returns the correct URL for the badge' do
      expect(notifier.url).to eq("/dashboard/badges/#{badge.id}")
    end
    
    context 'with different badge IDs' do
      let(:badge) { create(:badge, id: 999) }
      
      it 'uses the correct badge ID in URL' do
        expect(notifier.url).to eq("/dashboard/badges/999")
      end
    end
  end
  
  describe 'delivery' do
    it 'can be delivered to a user' do
      expect { notifier.deliver(user) }.not_to raise_error
    end
    
    it 'can be delivered later to a user' do
      expect { notifier.deliver_later(user) }.not_to raise_error
    end
    
    it 'can be delivered to multiple users' do
      users = create_list(:user, 3)
      expect { notifier.deliver(users) }.not_to raise_error
    end
  end
  
  describe 'params validation' do
    context 'without badge param' do
      let(:notifier) { described_class.with({}) }
      
      it 'raises an error when accessing message' do
        expect { notifier.message }.to raise_error(KeyError)
      end
      
      it 'raises an error when accessing url' do
        expect { notifier.url }.to raise_error(KeyError)
      end
    end
    
    context 'with nil badge' do
      let(:notifier) { described_class.with(badge: nil) }
      
      it 'raises an error when accessing message' do
        expect { notifier.message }.to raise_error(NoMethodError)
      end
      
      it 'raises an error when accessing url' do
        expect { notifier.url }.to raise_error(NoMethodError)
      end
    end
  end
  
  describe 'integration with Noticed' do
    it 'creates a notification record in database' do
      expect {
        notifier.deliver(user)
      }.to change { user.notifications.count }.by(1)
    end
    
    it 'stores the correct notification data' do
      notifier.deliver(user)
      
      notification = user.notifications.last
      expect(notification.type).to eq('BadgeAwardedNotifier')
      expect(notification.params['badge_id']).to eq(badge.id)
    end
  end
  
  describe 'usage patterns' do
    it 'supports method chaining' do
      expect {
        described_class
          .with(badge: badge)
          .deliver(user)
      }.not_to raise_error
    end
    
    it 'can be used with deliver_later' do
      expect {
        described_class
          .with(badge: badge)
          .deliver_later(user)
      }.not_to raise_error
    end
  end
  
  describe 'real-world scenarios' do
    context 'when badge is awarded through UserBadge model' do
      let(:user_badge) { create(:user_badge, user: user, badge: badge) }
      
      it 'can be triggered from badge award' do
        expect {
          described_class.with(badge: badge).deliver(user)
        }.to change { user.notifications.count }.by(1)
      end
    end
    
    context 'with multiple badge awards' do
      let(:badge1) { create(:badge, name: 'First Badge') }
      let(:badge2) { create(:badge, name: 'Second Badge') }
      
      it 'creates separate notifications for each badge' do
        expect {
          described_class.with(badge: badge1).deliver(user)
          described_class.with(badge: badge2).deliver(user)
        }.to change { user.notifications.count }.by(2)
      end
    end
  end
end