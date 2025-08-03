# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::ContentUnit::FindContentUnit, type: :graphql do
  let(:user) { create(:user) }
  let(:context) { { current_user: user, ability: Ability.new(user) } }
  let(:query) { described_class.new(object: nil, context: context, field: nil) }
  
  describe '#resolve' do
    let(:content_unit) { create(:content_unit, title: 'Ruby Basics') }
    
    context 'when content unit exists' do
      it 'returns the content unit by ID' do
        result = query.resolve(id: content_unit.id)
        
        expect(result).to eq(content_unit)
      end
      
      it 'returns content unit with correct attributes' do
        result = query.resolve(id: content_unit.id)
        
        expect(result.title).to eq('Ruby Basics')
        expect(result.id).to eq(content_unit.id)
      end
    end
    
    context 'when content unit does not exist' do
      it 'returns nil' do
        result = query.resolve(id: 99999)
        
        expect(result).to be_nil
      end
    end
    
    context 'with different content unit types' do
      let(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', title: 'Ruby Course') }
      let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', title: 'Control Flow') }
      let(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit', title: 'Conditionals') }
      let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', title: 'If Statements') }
      
      it 'finds course units' do
        result = query.resolve(id: course.id)
        expect(result).to eq(course)
        expect(result.type).to eq('ContentUnit::CourseUnit')
      end
      
      it 'finds module units' do
        result = query.resolve(id: module_unit.id)
        expect(result).to eq(module_unit)
        expect(result.type).to eq('ContentUnit::ModuleUnit')
      end
      
      it 'finds segment units' do
        result = query.resolve(id: segment.id)
        expect(result).to eq(segment)
        expect(result.type).to eq('ContentUnit::SegmentUnit')
      end
      
      it 'finds lesson units' do
        result = query.resolve(id: lesson.id)
        expect(result).to eq(lesson)
        expect(result.type).to eq('ContentUnit::LessonUnit')
      end
    end
    
    context 'with string ID' do
      it 'handles string IDs correctly' do
        result = query.resolve(id: content_unit.id.to_s)
        
        expect(result).to eq(content_unit)
      end
    end
    
    context 'with invalid ID format' do
      it 'returns nil for non-numeric string' do
        result = query.resolve(id: 'invalid')
        
        expect(result).to be_nil
      end
      
      it 'returns nil for empty string' do
        result = query.resolve(id: '')
        
        expect(result).to be_nil
      end
    end
    
    context 'with hierarchical content units' do
      let(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit') }
      let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', parent: course) }
      let(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit', parent: module_unit) }
      let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment) }
      
      it 'finds content units regardless of hierarchy level' do
        expect(query.resolve(id: course.id)).to eq(course)
        expect(query.resolve(id: module_unit.id)).to eq(module_unit)
        expect(query.resolve(id: segment.id)).to eq(segment)
        expect(query.resolve(id: lesson.id)).to eq(lesson)
      end
      
      it 'can access parent relationships' do
        result = query.resolve(id: lesson.id)
        
        expect(result.parent).to eq(segment)
        expect(result.parent.parent).to eq(module_unit)
        expect(result.parent.parent.parent).to eq(course)
      end
    end
  end
  
  describe 'query definition' do
    it 'has correct description' do
      expect(described_class.description).to eq('Find a single content unit by ID')
    end
    
    it 'returns ContentUnitInterface' do
      expect(described_class.type.to_s).to include('ContentUnitInterface')
    end
    
    it 'allows null return' do
      expect(described_class.type.non_null?).to be false
    end
    
    it 'requires ID argument' do
      expect(described_class.arguments['id']).to be_present
      expect(described_class.arguments['id'].type.non_null?).to be true
    end
  end
  
  describe 'integration with GraphQL schema' do
    let(:content_unit) { create(:content_unit, title: 'Test Unit', slug: 'test-unit') }
    let(:query_string) do
      <<~GRAPHQL
        query($id: ID!) {
          findContentUnit(id: $id) {
            id
            title
            slug
            type
          }
        }
      GRAPHQL
    end
    
    it 'returns content unit data through schema' do
      result = TheRubyTrainSchema.execute(
        query_string,
        variables: { id: content_unit.id },
        context: context
      )
      
      expect(result.dig('data', 'findContentUnit')).to be_present
      expect(result.dig('data', 'findContentUnit', 'id')).to eq(content_unit.id.to_s)
      expect(result.dig('data', 'findContentUnit', 'title')).to eq('Test Unit')
      expect(result.dig('data', 'findContentUnit', 'slug')).to eq('test-unit')
    end
    
    it 'returns null for non-existent content unit' do
      result = TheRubyTrainSchema.execute(
        query_string,
        variables: { id: 99999 },
        context: context
      )
      
      expect(result.dig('data', 'findContentUnit')).to be_nil
      expect(result['errors']).to be_nil
    end
  end
  
  describe 'performance considerations' do
    let(:content_unit) { create(:content_unit) }
    
    it 'executes only one query' do
      expect {
        query.resolve(id: content_unit.id)
      }.not_to exceed_query_limit(1)
    end
    
    it 'uses find_by instead of find to avoid exceptions' do
      expect(ContentUnit).to receive(:find_by).with(id: content_unit.id).and_call_original
      
      query.resolve(id: content_unit.id)
    end
  end
  
  describe 'error scenarios' do
    context 'when database error occurs' do
      before do
        allow(ContentUnit).to receive(:find_by).and_raise(ActiveRecord::ConnectionTimeoutError)
      end
      
      it 'propagates database errors' do
        expect {
          query.resolve(id: 1)
        }.to raise_error(ActiveRecord::ConnectionTimeoutError)
      end
    end
    
    context 'when ActiveRecord error occurs' do
      before do
        allow(ContentUnit).to receive(:find_by).and_raise(ActiveRecord::StatementInvalid)
      end
      
      it 'propagates ActiveRecord errors' do
        expect {
          query.resolve(id: 1)
        }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
  
  describe 'content unit states' do
    let(:visible_unit) { create(:content_unit, state: 'visible') }
    let(:draft_unit) { create(:content_unit, state: 'draft') }
    let(:archived_unit) { create(:content_unit, state: 'archived') }
    let(:deleted_unit) { create(:content_unit, state: 'deleted') }
    
    it 'finds content units in any state' do
      expect(query.resolve(id: visible_unit.id)).to eq(visible_unit)
      expect(query.resolve(id: draft_unit.id)).to eq(draft_unit)
      expect(query.resolve(id: archived_unit.id)).to eq(archived_unit)
      expect(query.resolve(id: deleted_unit.id)).to eq(deleted_unit)
    end
  end
  
  describe 'edge cases' do
    it 'handles nil ID gracefully' do
      result = query.resolve(id: nil)
      expect(result).to be_nil
    end
    
    it 'handles zero ID' do
      result = query.resolve(id: 0)
      expect(result).to be_nil
    end
    
    it 'handles negative ID' do
      result = query.resolve(id: -1)
      expect(result).to be_nil
    end
  end
end