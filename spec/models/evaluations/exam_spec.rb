# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluations::Exam, type: :model do
  subject(:exam) { build(:evaluation, type: 'Evaluations::Exam') }
  
  it 'is a valid Evaluation' do
    expect(exam).to be_valid
  end
  
  it 'inherits from Evaluation' do
    expect(exam).to be_a(Evaluation)
  end
  
  describe 'factory' do
    it 'creates a valid exam' do
      exam = create(:evaluation, type: 'Evaluations::Exam')
      expect(exam).to be_persisted
      expect(exam.type).to eq('Evaluations::Exam')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as Evaluation' do
      exam = create(:evaluation, type: 'Evaluations::Exam')
      expect(Evaluation.find(exam.id)).to be_a(Evaluations::Exam)
    end
    
    it 'can be queried specifically as Exam' do
      exam = create(:evaluation, type: 'Evaluations::Exam')
      expect(Evaluations::Exam.find(exam.id)).to be_a(Evaluations::Exam)
    end
  end
  
  describe 'exam characteristics' do
    let(:exam) { create(:evaluation, type: 'Evaluations::Exam') }
    
    it 'represents a formal evaluation' do
      expect(exam.type).to eq('Evaluations::Exam')
    end
    
    it 'can have evaluation sections' do
      section = create(:evaluation_section, evaluation: exam)
      expect(exam.evaluation_sections).to include(section)
    end
    
    it 'can have questions' do
      question = create(:question, evaluation: exam)
      expect(exam.questions).to include(question)
    end
    
    it 'can have submissions' do
      submission = create(:submission, evaluation: exam)
      expect(exam.submissions).to include(submission)
    end
  end
  
  describe 'inheritance behavior' do
    let(:exam) { create(:evaluation, type: 'Evaluations::Exam') }
    
    it 'inherits all Evaluation associations' do
      expect(exam).to respond_to(:content_unit)
      expect(exam).to respond_to(:questions)
      expect(exam).to respond_to(:submissions)
      expect(exam).to respond_to(:evaluation_sections)
      expect(exam).to respond_to(:evaluation_setting)
    end
    
    it 'inherits all Evaluation validations' do
      invalid_exam = build(:evaluation, type: 'Evaluations::Exam', title: nil)
      expect(invalid_exam).not_to be_valid
    end
    
    it 'inherits all Evaluation states' do
      expect(exam).to respond_to(:state)
      expect(exam.state).to eq('draft')
    end
  end
end