# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ContentUnit::CreateContentUnit, type: :graphql do
  let(:user) { create(:user) }
  let(:context) { { current_user: user, ability: Ability.new(user) } }
  let(:mutation) { described_class.new(object: nil, context: context, field: nil) }
  
  before do
    # Mock TYPES constant
    stub_const('ContentUnit::TYPES', ['ContentUnit::CourseUnit', 'ContentUnit::ModuleUnit', 'ContentUnit::SegmentUnit', 'ContentUnit::LessonUnit'])
  end
  
  describe '#resolve' do
    let(:valid_params) do
      {
        type: 'ContentUnit::CourseUnit',
        title: 'Ruby Fundamentals',
        slug: 'ruby-fundamentals',
        description: 'Learn the basics of Ruby programming'
      }
    end
    
    context 'with valid parameters' do
      it 'creates a content unit successfully' do
        result = mutation.resolve(**valid_params)
        
        expect(result[:content_unit]).to be_persisted
        expect(result[:content_unit].type).to eq('ContentUnit::CourseUnit')
        expect(result[:content_unit].title).to eq('Ruby Fundamentals')
        expect(result[:content_unit].slug).to eq('ruby-fundamentals')
        expect(result[:content_unit].description).to eq('Learn the basics of Ruby programming')
        expect(result[:content_unit].created_by).to eq(user.id)
        expect(result[:errors]).to be_empty
      end
      
      it 'assigns position when blank' do
        content_unit_double = double('ContentUnit', position: nil, save: true, errors: double(full_messages: []))
        allow(ContentUnit).to receive(:new).and_return(content_unit_double)
        allow(content_unit_double).to receive(:assign_position)
        
        mutation.resolve(**valid_params)
        
        expect(content_unit_double).to have_received(:assign_position)
      end
      
      it 'does not assign position when already set' do
        content_unit_double = double('ContentUnit', position: 1, save: true, errors: double(full_messages: []))
        allow(ContentUnit).to receive(:new).and_return(content_unit_double)
        allow(content_unit_double).to receive(:assign_position)
        
        mutation.resolve(**valid_params)
        
        expect(content_unit_double).not_to have_received(:assign_position)
      end
      
      context 'with parent_id' do
        let(:parent_unit) { create(:content_unit, type: 'ContentUnit::CourseUnit') }
        let(:params_with_parent) { valid_params.merge(parent_id: parent_unit.id) }
        
        it 'creates content unit with parent' do
          result = mutation.resolve(**params_with_parent)
          
          expect(result[:content_unit]).to be_persisted
          expect(result[:content_unit].parent_id).to eq(parent_unit.id)
          expect(result[:errors]).to be_empty
        end
      end
      
      context 'with different content unit types' do
        it 'creates module unit' do
          params = valid_params.merge(type: 'ContentUnit::ModuleUnit')
          result = mutation.resolve(**params)
          
          expect(result[:content_unit].type).to eq('ContentUnit::ModuleUnit')
          expect(result[:errors]).to be_empty
        end
        
        it 'creates segment unit' do
          params = valid_params.merge(type: 'ContentUnit::SegmentUnit')
          result = mutation.resolve(**params)
          
          expect(result[:content_unit].type).to eq('ContentUnit::SegmentUnit')
          expect(result[:errors]).to be_empty
        end
        
        it 'creates lesson unit' do
          params = valid_params.merge(type: 'ContentUnit::LessonUnit')
          result = mutation.resolve(**params)
          
          expect(result[:content_unit].type).to eq('ContentUnit::LessonUnit')
          expect(result[:errors]).to be_empty
        end
      end
    end
    
    context 'with invalid type' do
      let(:invalid_params) { valid_params.merge(type: 'InvalidType') }
      
      it 'returns error for invalid type' do
        result = mutation.resolve(**invalid_params)
        
        expect(result[:content_unit]).to be_nil
        expect(result[:errors]).to include('Invalid type')
      end
    end
    
    context 'with validation errors' do
      let(:invalid_params) { valid_params.merge(title: '') }
      
      it 'returns validation errors when save fails' do
        result = mutation.resolve(**invalid_params)
        
        expect(result[:content_unit]).to be_nil
        expect(result[:errors]).not_to be_empty
      end
    end
    
    context 'when user is not authenticated' do
      let(:context) { { current_user: nil } }
      
      it 'uses default user ID (15)' do
        result = mutation.resolve(**valid_params)
        
        expect(result[:content_unit]).to be_persisted
        expect(result[:content_unit].created_by).to eq(15)
      end
    end
    
    context 'with duplicate slug' do
      let!(:existing_unit) { create(:content_unit, slug: 'ruby-fundamentals') }
      
      it 'returns validation error for duplicate slug' do
        result = mutation.resolve(**valid_params)
        
        expect(result[:content_unit]).to be_nil
        expect(result[:errors]).not_to be_empty
      end
    end
    
    describe 'field definitions' do
      it 'defines the correct arguments' do
        expect(described_class.arguments.keys).to include(
          'type', 'title', 'slug', 'description', 'parentId'
        )
      end
      
      it 'defines the correct return fields' do
        expect(described_class.fields.keys).to include('contentUnit', 'errors')
      end
      
      it 'has correct argument requirements' do
        expect(described_class.arguments['type'].type.non_null?).to be true
        expect(described_class.arguments['title'].type.non_null?).to be true
        expect(described_class.arguments['slug'].type.non_null?).to be true
        expect(described_class.arguments['description'].type.non_null?).to be true
        expect(described_class.arguments['parentId'].type.non_null?).to be false
      end
    end
    
    describe 'ContentUnit model integration' do
      it 'creates the correct model instance' do
        expect {
          mutation.resolve(**valid_params)
        }.to change { ContentUnit.count }.by(1)
      end
      
      it 'sets all required attributes' do
        result = mutation.resolve(**valid_params)
        content_unit = result[:content_unit]
        
        expect(content_unit.type).to eq(valid_params[:type])
        expect(content_unit.title).to eq(valid_params[:title])
        expect(content_unit.slug).to eq(valid_params[:slug])
        expect(content_unit.description).to eq(valid_params[:description])
        expect(content_unit.created_by).to eq(user.id)
      end
    end
    
    describe 'hierarchical content creation' do
      let(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit') }
      let(:module_params) do
        {
          type: 'ContentUnit::ModuleUnit',
          title: 'Control Flow',
          slug: 'control-flow',
          description: 'Learn about conditionals and loops',
          parent_id: course.id
        }
      end
      
      it 'creates hierarchical content structure' do
        result = mutation.resolve(**module_params)
        
        expect(result[:content_unit]).to be_persisted
        expect(result[:content_unit].parent).to eq(course)
        expect(result[:errors]).to be_empty
      end
    end
    
    describe 'error scenarios' do
      context 'when ContentUnit.new raises error' do
        before do
          allow(ContentUnit).to receive(:new).and_raise(StandardError.new('Unexpected error'))
        end
        
        it 'raises the error' do
          expect {
            mutation.resolve(**valid_params)
          }.to raise_error(StandardError, 'Unexpected error')
        end
      end
      
      context 'when save fails with exception' do
        before do
          content_unit = build(:content_unit)
          allow(ContentUnit).to receive(:new).and_return(content_unit)
          allow(content_unit).to receive(:save).and_raise(ActiveRecord::RecordInvalid)
        end
        
        it 'propagates the exception' do
          expect {
            mutation.resolve(**valid_params)
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end