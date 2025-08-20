# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentUnit::LessonUnit, type: :model do
  subject(:lesson_unit) { build(:content_unit, type: 'ContentUnit::LessonUnit') }
  
  it 'is a valid ContentUnit' do
    expect(lesson_unit).to be_valid
  end
  
  it 'inherits from ContentUnit' do
    expect(lesson_unit).to be_a(ContentUnit)
  end
  
  it 'includes CustomStiName' do
    expect(described_class).to include(CustomStiName)
  end
  
  describe 'factory' do
    it 'creates a valid lesson unit' do
      lesson_unit = create(:content_unit, type: 'ContentUnit::LessonUnit')
      expect(lesson_unit).to be_persisted
      expect(lesson_unit.type).to eq('ContentUnit::LessonUnit')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as ContentUnit' do
      lesson_unit = create(:content_unit, type: 'ContentUnit::LessonUnit')
      expect(ContentUnit.find(lesson_unit.id)).to be_a(ContentUnit::LessonUnit)
    end
    
    it 'can be queried specifically as LessonUnit' do
      lesson_unit = create(:content_unit, type: 'ContentUnit::LessonUnit')
      expect(ContentUnit::LessonUnit.find(lesson_unit.id)).to be_a(ContentUnit::LessonUnit)
    end
  end
  
  describe 'attachments' do
    let(:lesson_unit) { create(:content_unit, type: 'ContentUnit::LessonUnit') }
    
    it 'has rich text content' do
      expect(lesson_unit).to respond_to(:rich_body_html)
    end
    
    it 'can have a video attachment' do
      expect(lesson_unit).to respond_to(:video)
    end
    
    it 'can have an image attachment' do
      expect(lesson_unit).to respond_to(:image)
    end
  end
  
  describe 'navigation methods' do
    let(:segment_unit) { create(:content_unit, type: 'ContentUnit::SegmentUnit') }
    let!(:lesson1) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment_unit, position: 1, slug: 'lesson-1') }
    let!(:lesson2) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment_unit, position: 2, slug: 'lesson-2') }
    let!(:lesson3) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment_unit, position: 3, slug: 'lesson-3') }
    
    describe '#next_slug' do
      it 'returns the slug of the next lesson' do
        expect(lesson1.next_slug).to eq('lesson-2')
        expect(lesson2.next_slug).to eq('lesson-3')
      end
      
      it 'returns nil for the last lesson' do
        expect(lesson3.next_slug).to be_nil
      end
    end
    
    describe '#previous_slug' do
      it 'returns the slug of the previous lesson' do
        expect(lesson2.previous_slug).to eq('lesson-1')
        expect(lesson3.previous_slug).to eq('lesson-2')
      end
      
      it 'returns nil for the first lesson' do
        expect(lesson1.previous_slug).to be_nil
      end
    end
  end
  
  describe 'hierarchy' do
    let(:segment_unit) { create(:content_unit, type: 'ContentUnit::SegmentUnit') }
    let(:lesson_unit) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment_unit) }
    
    it 'can belong to a segment' do
      expect(lesson_unit.parent).to eq(segment_unit)
    end
    
    it 'should be at the bottom of the hierarchy' do
      expect(lesson_unit.children).to be_empty
    end
  end
end