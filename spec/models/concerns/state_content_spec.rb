# frozen_string_literal: true

require 'rails_helper'

class TestContentModel < ActiveRecord::Base
  self.table_name = 'content_units'
  include StateContent
end

RSpec.describe StateContent, type: :concern do
  let(:user) { create(:user) }
  let(:content) { TestContentModel.create!(title: 'Test', created_by: user.id) }
  
  describe 'enum states' do
    it 'defines the correct enum values' do
      expect(TestContentModel.states).to eq({
        'draft' => 0,
        'visible' => 1,
        'archived' => 2,
        'deleted' => 3
      })
    end
    
    it 'defaults to draft state' do
      expect(content.state).to eq('draft')
    end
  end
  
  describe 'validations' do
    it 'validates presence of state' do
      content = TestContentModel.new(title: 'Test', state: nil)
      expect(content).not_to be_valid
      expect(content.errors[:state]).to include("can't be blank")
    end
  end
  
  describe 'scopes' do
    let!(:draft_content) { TestContentModel.create!(title: 'Draft', state: 'draft', created_by: user.id) }
    let!(:visible_content) { TestContentModel.create!(title: 'Visible', state: 'visible', created_by: user.id) }
    let!(:archived_content) { TestContentModel.create!(title: 'Archived', state: 'archived', created_by: user.id) }
    let!(:deleted_content) { TestContentModel.create!(title: 'Deleted', state: 'deleted', created_by: user.id) }
    
    it 'filters by draft state' do
      expect(TestContentModel.draft).to include(draft_content)
      expect(TestContentModel.draft).not_to include(visible_content)
    end
    
    it 'filters by visible state' do
      expect(TestContentModel.visible).to include(visible_content)
      expect(TestContentModel.visible).not_to include(draft_content)
    end
    
    it 'filters by archived state' do
      expect(TestContentModel.archived).to include(archived_content)
      expect(TestContentModel.archived).not_to include(visible_content)
    end
    
    it 'filters by deleted state' do
      expect(TestContentModel.deleted).to include(deleted_content)
      expect(TestContentModel.deleted).not_to include(visible_content)
    end
  end
  
  describe 'state predicate methods' do
    it 'correctly identifies draft state' do
      content.update!(state: 'draft')
      expect(content).to be_draft
      expect(content).not_to be_visible
    end
    
    it 'correctly identifies visible state' do
      content.update!(state: 'visible')
      expect(content).to be_visible
      expect(content).not_to be_draft
    end
    
    it 'correctly identifies archived state' do
      content.update!(state: 'archived')
      expect(content).to be_archived
      expect(content).not_to be_visible
    end
    
    it 'correctly identifies hidden/deleted state' do
      content.update!(state: 'deleted')
      expect(content).to be_hidden
      expect(content).not_to be_visible
    end
  end
  
  describe '#visible_for?' do
    context 'when content is visible' do
      before { content.update!(state: 'visible') }
      
      it 'returns true for any user' do
        other_user = create(:user)
        expect(content.visible_for?(user)).to be true
        expect(content.visible_for?(other_user)).to be true
      end
    end
    
    context 'when content is draft' do
      before { content.update!(state: 'draft') }
      
      it 'returns true for creator' do
        expect(content.visible_for?(user)).to be true
      end
      
      it 'returns false for other users' do
        other_user = create(:user)
        expect(content.visible_for?(other_user)).to be false
      end
    end
    
    context 'when content is archived' do
      before { content.update!(state: 'archived') }
      
      it 'returns true for creator' do
        expect(content.visible_for?(user)).to be true
      end
      
      it 'returns false for other users' do
        other_user = create(:user)
        expect(content.visible_for?(other_user)).to be false
      end
    end
    
    context 'when content is deleted' do
      before { content.update!(state: 'deleted') }
      
      it 'returns false for any user including creator' do
        other_user = create(:user)
        expect(content.visible_for?(user)).to be false
        expect(content.visible_for?(other_user)).to be false
      end
    end
  end
  
  describe '#creator?' do
    it 'returns true when user is the creator' do
      expect(content.creator?(user)).to be true
    end
    
    it 'returns false when user is not the creator' do
      other_user = create(:user)
      expect(content.creator?(other_user)).to be false
    end
  end
  
  describe 'integration with actual models' do
    it 'works with ContentUnit' do
      content_unit = create(:content_unit, created_by: user.id)
      expect(content_unit).to respond_to(:draft?)
      expect(content_unit).to respond_to(:visible?)
      expect(content_unit).to respond_to(:visible_for?)
      expect(content_unit.creator?(user)).to be true
    end
    
    it 'works with Topic' do
      topic = create(:topic, created_by: user.id)
      expect(topic).to respond_to(:draft?)
      expect(topic).to respond_to(:visible?)
      expect(topic).to respond_to(:visible_for?)
      expect(topic.creator?(user)).to be true
    end
  end
end