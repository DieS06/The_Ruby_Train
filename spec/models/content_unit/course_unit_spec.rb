# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentUnit::CourseUnit, type: :model do
  subject(:course_unit) { build(:content_unit, type: 'ContentUnit::CourseUnit') }
  
  it 'is a valid ContentUnit' do
    expect(course_unit).to be_valid
  end
  
  it 'inherits from ContentUnit' do
    expect(course_unit).to be_a(ContentUnit)
  end
  
  it 'includes CustomStiName' do
    expect(described_class).to include(CustomStiName)
  end
  
  describe 'factory' do
    it 'creates a valid course unit' do
      course_unit = create(:content_unit, type: 'ContentUnit::CourseUnit')
      expect(course_unit).to be_persisted
      expect(course_unit.type).to eq('ContentUnit::CourseUnit')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as ContentUnit' do
      course_unit = create(:content_unit, type: 'ContentUnit::CourseUnit')
      expect(ContentUnit.find(course_unit.id)).to be_a(ContentUnit::CourseUnit)
    end
    
    it 'can be queried specifically as CourseUnit' do
      course_unit = create(:content_unit, type: 'ContentUnit::CourseUnit')
      expect(ContentUnit::CourseUnit.find(course_unit.id)).to be_a(ContentUnit::CourseUnit)
    end
  end
  
  describe 'hierarchy' do
    let(:course_unit) { create(:content_unit, type: 'ContentUnit::CourseUnit') }
    let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', parent: course_unit) }
    
    it 'can have module children' do
      expect(course_unit.children).to include(module_unit)
    end
    
    it 'should be at the top of the hierarchy' do
      expect(course_unit.parent).to be_nil
    end
  end
end