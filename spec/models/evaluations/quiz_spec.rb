# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluations::Quiz, type: :model do
  subject(:quiz) { build(:evaluation, type: 'Evaluations::Quiz') }
  
  it 'is a valid Evaluation' do
    expect(quiz).to be_valid
  end
  
  it 'inherits from Evaluation' do
    expect(quiz).to be_a(Evaluation)
  end
  
  describe 'factory' do
    it 'creates a valid quiz' do
      quiz = create(:evaluation, type: 'Evaluations::Quiz')
      expect(quiz).to be_persisted
      expect(quiz.type).to eq('Evaluations::Quiz')
    end
  end
  
  describe 'STI behavior' do
    it 'can be queried as Evaluation' do
      quiz = create(:evaluation, type: 'Evaluations::Quiz')
      expect(Evaluation.find(quiz.id)).to be_a(Evaluations::Quiz)
    end
    
    it 'can be queried specifically as Quiz' do
      quiz = create(:evaluation, type: 'Evaluations::Quiz')
      expect(Evaluations::Quiz.find(quiz.id)).to be_a(Evaluations::Quiz)
    end
  end
  
  describe 'quiz characteristics' do
    let(:quiz) { create(:evaluation, type: 'Evaluations::Quiz') }
    
    it 'represents a lightweight evaluation' do
      expect(quiz.type).to eq('Evaluations::Quiz')
    end
    
    it 'can have questions for quick testing' do
      question = create(:question, evaluation: quiz)
      expect(quiz.questions).to include(question)
    end
    
    it 'can have submissions for practice' do
      submission = create(:submission, evaluation: quiz)
      expect(quiz.submissions).to include(submission)
    end
  end
  
  describe 'inheritance behavior' do
    let(:quiz) { create(:evaluation, type: 'Evaluations::Quiz') }
    
    it 'inherits all Evaluation associations' do
      expect(quiz).to respond_to(:content_unit)
      expect(quiz).to respond_to(:questions)
      expect(quiz).to respond_to(:submissions)
      expect(quiz).to respond_to(:evaluation_sections)
      expect(quiz).to respond_to(:evaluation_setting)
    end
    
    it 'inherits all Evaluation validations' do
      invalid_quiz = build(:evaluation, type: 'Evaluations::Quiz', title: nil)
      expect(invalid_quiz).not_to be_valid
    end
    
    it 'inherits all Evaluation states' do
      expect(quiz).to respond_to(:state)
      expect(quiz.state).to eq('draft')
    end
  end
  
  describe 'usage for practice and quick testing' do
    let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit') }
    let(:quiz) { create(:evaluation, type: 'Evaluations::Quiz', content_unit: lesson) }
    
    it 'can be associated with lessons for practice' do
      expect(quiz.content_unit).to eq(lesson)
    end
    
    it 'can have multiple questions for quick assessment' do
      questions = create_list(:question, 3, evaluation: quiz)
      expect(quiz.questions.count).to eq(3)
      expect(quiz.questions).to match_array(questions)
    end
  end
end