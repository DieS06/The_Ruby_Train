# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BadgeAssigner, type: :service do
  let(:user) { create(:user) }
  let(:badge_assigner) { described_class.new(user) }
  
  describe '#call' do
    let!(:active_badge) { create(:badge, state: 'visible') }
    let!(:inactive_badge) { create(:badge, state: 'hidden') }
    
    before do
      allow(Badge).to receive(:active_badges).and_return(Badge.where(id: active_badge.id))
      allow(BadgeCriteriaEvaluator).to receive(:new).and_return(double(satisfied?: true))
      allow(UserBadge).to receive(:award_badge)
    end
    
    it 'evaluates active badges only' do
      badge_assigner.call
      expect(Badge).to have_received(:active_badges)
    end
    
    it 'skips badges already awarded to user' do
      create(:user_badge, user: user, badge: active_badge)
      
      badge_assigner.call
      
      expect(BadgeCriteriaEvaluator).not_to have_received(:new)
      expect(UserBadge).not_to have_received(:award_badge)
    end
    
    it 'evaluates criteria for badges not yet awarded' do
      badge_assigner.call
      
      expect(BadgeCriteriaEvaluator).to have_received(:new).with(user: user, badge: active_badge)
    end
    
    context 'when badge criteria is satisfied' do
      before do
        allow(BadgeCriteriaEvaluator).to receive(:new).and_return(double(satisfied?: true))
      end
      
      it 'awards the badge to the user' do
        badge_assigner.call
        
        expect(UserBadge).to have_received(:award_badge).with(user, active_badge)
      end
    end
    
    context 'when badge criteria is not satisfied' do
      before do
        allow(BadgeCriteriaEvaluator).to receive(:new).and_return(double(satisfied?: false))
      end
      
      it 'does not award the badge' do
        badge_assigner.call
        
        expect(UserBadge).not_to have_received(:award_badge)
      end
    end
    
    context 'with multiple badges' do
      let!(:badge1) { create(:badge, state: 'visible') }
      let!(:badge2) { create(:badge, state: 'visible') }
      let!(:badge3) { create(:badge, state: 'visible') }
      
      before do
        allow(Badge).to receive(:active_badges).and_return(Badge.where(id: [badge1.id, badge2.id, badge3.id]))
      end
      
      it 'evaluates all active badges' do
        evaluator1 = double(satisfied?: true)
        evaluator2 = double(satisfied?: false)
        evaluator3 = double(satisfied?: true)
        
        allow(BadgeCriteriaEvaluator).to receive(:new).with(user: user, badge: badge1).and_return(evaluator1)
        allow(BadgeCriteriaEvaluator).to receive(:new).with(user: user, badge: badge2).and_return(evaluator2)
        allow(BadgeCriteriaEvaluator).to receive(:new).with(user: user, badge: badge3).and_return(evaluator3)
        
        badge_assigner.call
        
        expect(UserBadge).to have_received(:award_badge).with(user, badge1)
        expect(UserBadge).not_to have_received(:award_badge).with(user, badge2)
        expect(UserBadge).to have_received(:award_badge).with(user, badge3)
      end
      
      it 'handles badges already awarded' do
        create(:user_badge, user: user, badge: badge1)
        
        evaluator2 = double(satisfied?: true)
        evaluator3 = double(satisfied?: false)
        
        allow(BadgeCriteriaEvaluator).to receive(:new).with(user: user, badge: badge2).and_return(evaluator2)
        allow(BadgeCriteriaEvaluator).to receive(:new).with(user: user, badge: badge3).and_return(evaluator3)
        
        badge_assigner.call
        
        expect(BadgeCriteriaEvaluator).not_to have_received(:new).with(user: user, badge: badge1)
        expect(UserBadge).to have_received(:award_badge).with(user, badge2)
        expect(UserBadge).not_to have_received(:award_badge).with(user, badge3)
      end
    end
    
    describe 'integration behavior' do
      it 'processes all badges without errors' do
        expect { badge_assigner.call }.not_to raise_error
      end
      
      it 'can be called multiple times safely' do
        badge_assigner.call
        expect { badge_assigner.call }.not_to raise_error
      end
    end
  end
  
  describe 'initialization' do
    it 'requires a user' do
      expect { described_class.new(user) }.not_to raise_error
      expect(badge_assigner.instance_variable_get(:@user)).to eq(user)
    end
  end
end