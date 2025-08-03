# frozen_string_literal: true

require 'rails_helper'

class TestStiModel < ActiveRecord::Base
  self.table_name = 'content_units'
  include CustomStiName
end

class TestUnit < TestStiModel
end

class TestModuleUnit < TestStiModel
end

RSpec.describe CustomStiName, type: :concern do
  describe '.sti_name' do
    it 'removes "Unit" suffix from class name' do
      expect(TestModuleUnit.sti_name).to eq('TestModule')
    end
    
    it 'returns demodulized name when no "Unit" suffix' do
      expect(TestStiModel.sti_name).to eq('TestStiModel')
    end
    
    it 'works with nested classes' do
      module TestNamespace
        class CourseUnit < TestStiModel
        end
      end
      
      expect(TestNamespace::CourseUnit.sti_name).to eq('Course')
    end
    
    it 'handles classes without Unit suffix' do
      expect(TestUnit.sti_name).to eq('Test')
    end
  end
  
  describe 'integration with actual models' do
    it 'works with ContentUnit subclasses' do
      expect(ContentUnit::CourseUnit.sti_name).to eq('Course')
      expect(ContentUnit::ModuleUnit.sti_name).to eq('Module')
      expect(ContentUnit::SegmentUnit.sti_name).to eq('Segment')
      expect(ContentUnit::LessonUnit.sti_name).to eq('Lesson')
    end
  end
end