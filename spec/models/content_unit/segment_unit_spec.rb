# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentUnit::SegmentUnit, type: :model do
  subject(:segment_unit) { build(:content_unit, type: 'ContentUnit::SegmentUnit') }
  
  it 'is a valid ContentUnit' do
    expect(segment_unit).to be_valid
  end
  
  it 'inherits from ContentUnit' do
    expect(segment_unit).to be_a(ContentUnit)
  end
  
  it 'includes CustomStiName' do
    expect(described_class).to include(CustomStiName)
  end
  
  describe 'factory' do
    it 'creates a valid segment unit' do
      segment_unit = create(:content_unit, type: 'ContentUnit::SegmentUnit')
      expect(segment_unit).to be_persisted
      expect(segment_unit.type).to eq('ContentUnit::SegmentUnit')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as ContentUnit' do
      segment_unit = create(:content_unit, type: 'ContentUnit::SegmentUnit')
      expect(ContentUnit.find(segment_unit.id)).to be_a(ContentUnit::SegmentUnit)
    end
    
    it 'can be queried specifically as SegmentUnit' do
      segment_unit = create(:content_unit, type: 'ContentUnit::SegmentUnit')
      expect(ContentUnit::SegmentUnit.find(segment_unit.id)).to be_a(ContentUnit::SegmentUnit)
    end
  end
  
  describe 'hierarchy' do
    let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit') }
    let(:segment_unit) { create(:content_unit, type: 'ContentUnit::SegmentUnit', parent: module_unit) }
    let(:lesson_unit) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment_unit) }
    
    it 'can belong to a module' do
      expect(segment_unit.parent).to eq(module_unit)
    end
    
    it 'can have lesson children' do
      expect(segment_unit.children).to include(lesson_unit)
    end
    
    it 'is in the middle of the hierarchy' do
      expect(segment_unit.parent).to be_present
      expect(segment_unit.children).to be_present
    end
  end
end