require 'rails_helper'

RSpec.describe ContentUnit, type: :model do
  describe 'validations' do
    it 'is valid with all required attributes' do
      unit = build(:course)
      expect(unit).to be_valid
    end

    it 'is invalid without title' do
      unit = build(:course, title: nil)
      expect(unit).to be_invalid
      expect(unit.errors[:title]).to be_present
    end

    it 'is invalid with short description' do
      unit = build(:course, description: 'short')
      expect(unit).to be_invalid
    end

    it 'is invalid with unexpected type' do
      unit = build(:content_unit, type: 'InvalidType')
      expect(unit).to be_invalid
    end
  end

  describe 'hierarchy enforcement' do
    it 'allows Module under Course' do
      course = create(:course)
      mod = build(:module_unit, parent: course)
      expect(mod).to be_valid
    end

    it 'rejects Segment under Course' do
      course = create(:course)
      segment = build(:segment, parent: course)
      expect(segment).to be_invalid
    end

    it 'rejects Lesson under Course' do
      course = create(:course)
      lesson = build(:lesson, parent: course)
      expect(lesson).to be_invalid
    end

    it 'allows Segment under Module' do
      mod = create(:module_unit)
      segment = build(:segment, parent: mod)
      expect(segment).to be_valid
    end

    it 'allows Lesson under Segment' do
      segment = create(:segment)
      lesson = build(:lesson, parent: segment)
      expect(lesson).to be_valid
    end
  end

  describe '#destroy' do
    it 'soft deletes the record' do
      unit = create(:course)
      unit.destroy
      expect(unit.state).to eq('deleted')
      expect(unit.deleted_at).to be_present
    end
  end
end
