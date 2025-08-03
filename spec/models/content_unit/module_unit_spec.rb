# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentUnit::ModuleUnit, type: :model do
  subject(:module_unit) { build(:content_unit, type: 'ContentUnit::ModuleUnit') }
  
  it 'is a valid ContentUnit' do
    expect(module_unit).to be_valid
  end
  
  it 'inherits from ContentUnit' do
    expect(module_unit).to be_a(ContentUnit)
  end
  
  it 'includes CustomStiName' do
    expect(described_class).to include(CustomStiName)
  end
  
  describe 'factory' do
    it 'creates a valid module unit' do
      module_unit = create(:content_unit, type: 'ContentUnit::ModuleUnit')
      expect(module_unit).to be_persisted
      expect(module_unit.type).to eq('ContentUnit::ModuleUnit')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as ContentUnit' do
      module_unit = create(:content_unit, type: 'ContentUnit::ModuleUnit')
      expect(ContentUnit.find(module_unit.id)).to be_a(ContentUnit::ModuleUnit)
    end
    
    it 'can be queried specifically as ModuleUnit' do
      module_unit = create(:content_unit, type: 'ContentUnit::ModuleUnit')
      expect(ContentUnit::ModuleUnit.find(module_unit.id)).to be_a(ContentUnit::ModuleUnit)
    end
  end
  
  describe 'hierarchy' do
    let(:course_unit) { create(:content_unit, type: 'ContentUnit::CourseUnit') }
    let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', parent: course_unit) }
    let(:segment_unit) { create(:content_unit, type: 'ContentUnit::SegmentUnit', parent: module_unit) }
    
    it 'can belong to a course' do
      expect(module_unit.parent).to eq(course_unit)
    end
    
    it 'can have segment children' do
      expect(module_unit.children).to include(segment_unit)
    end
    
    it 'is in the middle of the hierarchy' do
      expect(module_unit.parent).to be_present
      expect(module_unit.children).to be_present
    end
  end
end