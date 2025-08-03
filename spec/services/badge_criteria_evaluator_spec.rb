# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BadgeCriteriaEvaluator, type: :service do
  let(:user) { create(:user) }
  let(:badge) { create(:badge, criteria: criteria) }
  let(:evaluator) { described_class.new(user: user, badge: badge) }
  
  describe '#satisfied?' do
    context 'with lesson criteria' do
      let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit') }
      let(:criteria) do
        {
          'type' => 'lesson',
          'conditions' => {
            'lesson_id' => lesson.id
          }
        }
      end
      
      context 'when lesson is completed with perfect score' do
        let!(:progress) { create(:progress, user: user, content_unit: lesson, state: 'passed', score: 100) }
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when lesson is not passed' do
        let!(:progress) { create(:progress, user: user, content_unit: lesson, state: 'failed', score: 100) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
      
      context 'when lesson score is below 100' do
        let!(:progress) { create(:progress, user: user, content_unit: lesson, state: 'passed', score: 95) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
      
      context 'when no progress exists' do
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
    end
    
    context 'with segment criteria' do
      let(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit') }
      let(:lesson1) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment) }
      let(:lesson2) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment) }
      let(:quiz) { create(:evaluation, type: 'Evaluations::Quiz', content_unit: segment) }
      let(:criteria) do
        {
          'type' => 'segment',
          'conditions' => {
            'segment_id' => segment.id
          }
        }
      end
      
      context 'when all lessons are passed and quiz score is high enough' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:progress2) { create(:progress, user: user, content_unit: lesson2, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 85) }
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when not all lessons are passed' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 85) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
      
      context 'when quiz score is too low' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:progress2) { create(:progress, user: user, content_unit: lesson2, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 75) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
      
      context 'when no quiz exists' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:progress2) { create(:progress, user: user, content_unit: lesson2, state: 'passed') }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
    end
    
    context 'with module criteria' do
      let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit') }
      let(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit', parent: module_unit) }
      let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: segment) }
      let(:exam) { create(:evaluation, type: 'Evaluations::Exam', content_unit: module_unit) }
      let(:criteria) do
        {
          'type' => 'module',
          'conditions' => {
            'module_id' => module_unit.id
          }
        }
      end
      
      context 'when all lessons are passed and exam score is high enough' do
        let!(:progress) { create(:progress, user: user, content_unit: lesson, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: exam, state: 'graded', score: 85) }
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when exam score is too low' do
        let!(:progress) { create(:progress, user: user, content_unit: lesson, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: exam, state: 'graded', score: 75) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
    end
    
    context 'with quiz criteria' do
      let(:quiz) { create(:evaluation, type: 'Evaluations::Quiz') }
      let(:criteria) do
        {
          'type' => 'quiz',
          'conditions' => {
            'evaluation_id' => quiz.id
          }
        }
      end
      
      context 'when quiz score meets threshold' do
        let!(:submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 85) }
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when quiz score is below threshold' do
        let!(:submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 75) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
      
      context 'when multiple submissions exist' do
        let!(:old_submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 75, created_at: 2.days.ago) }
        let!(:new_submission) { create(:submission, user: user, evaluation: quiz, state: 'graded', score: 85, created_at: 1.day.ago) }
        
        it 'uses the most recent submission' do
          expect(evaluator.satisfied?).to be true
        end
      end
    end
    
    context 'with exam criteria' do
      let(:exam) { create(:evaluation, type: 'Evaluations::Exam') }
      let(:criteria) do
        {
          'type' => 'exam',
          'conditions' => {
            'evaluation_id' => exam.id
          }
        }
      end
      
      context 'when exam score meets threshold' do
        let!(:submission) { create(:submission, user: user, evaluation: exam, state: 'graded', score: 85) }
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when exam score is below threshold' do
        let!(:submission) { create(:submission, user: user, evaluation: exam, state: 'graded', score: 75) }
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
    end
    
    context 'with silver criteria (complete all courses)' do
      let(:criteria) { { 'type' => 'silver' } }
      let(:lesson1) { create(:content_unit, type: 'ContentUnit::LessonUnit') }
      let(:lesson2) { create(:content_unit, type: 'ContentUnit::LessonUnit') }
      let(:final_exam) { create(:evaluation, type: 'Evaluations::Exam') }
      
      context 'when all lessons are passed and final exam score is high enough' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:progress2) { create(:progress, user: user, content_unit: lesson2, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: final_exam, state: 'graded', score: 85) }
        
        before do
          allow(ContentUnit).to receive(:where).with(type: 'LessonUnit').and_return([lesson1, lesson2])
          allow(Evaluation).to receive(:where).with(type: 'Exam').and_return(double(order: double(last: final_exam)))
        end
        
        it 'returns true' do
          expect(evaluator.satisfied?).to be true
        end
      end
      
      context 'when not all lessons are completed' do
        let!(:progress1) { create(:progress, user: user, content_unit: lesson1, state: 'passed') }
        let!(:submission) { create(:submission, user: user, evaluation: final_exam, state: 'graded', score: 85) }
        
        before do
          allow(ContentUnit).to receive(:where).with(type: 'LessonUnit').and_return([lesson1, lesson2])
        end
        
        it 'returns false' do
          expect(evaluator.satisfied?).to be false
        end
      end
    end
    
    context 'with trophy criteria' do
      context 'for perfect quizzes' do
        let(:criteria) do
          {
            'type' => 'trophy',
            'conditions' => {
              'tag' => 'perfect_quizzes',
              'count' => 3
            }
          }
        end
        let(:quiz1) { create(:evaluation, type: 'Evaluations::Quiz') }
        let(:quiz2) { create(:evaluation, type: 'Evaluations::Quiz') }
        let(:quiz3) { create(:evaluation, type: 'Evaluations::Quiz') }
        
        context 'when user has enough perfect quiz scores' do
          let!(:submission1) { create(:submission, user: user, evaluation: quiz1, state: 'graded', score: 100) }
          let!(:submission2) { create(:submission, user: user, evaluation: quiz2, state: 'graded', score: 100) }
          let!(:submission3) { create(:submission, user: user, evaluation: quiz3, state: 'graded', score: 100) }
          
          before do
            allow(Evaluation).to receive(:where).with(type: 'Quiz').and_return([quiz1, quiz2, quiz3])
          end
          
          it 'returns true' do
            expect(evaluator.satisfied?).to be true
          end
        end
        
        context 'when user does not have enough perfect scores' do
          let!(:submission1) { create(:submission, user: user, evaluation: quiz1, state: 'graded', score: 100) }
          let!(:submission2) { create(:submission, user: user, evaluation: quiz2, state: 'graded', score: 95) }
          
          before do
            allow(Evaluation).to receive(:where).with(type: 'Quiz').and_return([quiz1, quiz2, quiz3])
          end
          
          it 'returns false' do
            expect(evaluator.satisfied?).to be false
          end
        end
      end
      
      context 'for perfect exams' do
        let(:criteria) do
          {
            'type' => 'trophy',
            'conditions' => {
              'tag' => 'perfect_exams',
              'count' => 2
            }
          }
        end
        let(:exam1) { create(:evaluation, type: 'Evaluations::Exam') }
        let(:exam2) { create(:evaluation, type: 'Evaluations::Exam') }
        
        context 'when user has enough perfect exam scores' do
          let!(:submission1) { create(:submission, user: user, evaluation: exam1, state: 'graded', score: 100) }
          let!(:submission2) { create(:submission, user: user, evaluation: exam2, state: 'graded', score: 100) }
          
          before do
            allow(Evaluation).to receive(:where).with(type: 'Exam').and_return([exam1, exam2])
          end
          
          it 'returns true' do
            expect(evaluator.satisfied?).to be true
          end
        end
      end
    end
    
    context 'with unknown criteria type' do
      let(:criteria) { { 'type' => 'unknown' } }
      
      it 'returns false' do
        expect(evaluator.satisfied?).to be false
      end
    end
    
    context 'with nil criteria' do
      let(:badge) { create(:badge, criteria: nil) }
      
      it 'returns false' do
        expect(evaluator.satisfied?).to be false
      end
    end
  end
  
  describe 'initialization' do
    it 'stores user and badge' do
      expect(evaluator.instance_variable_get(:@user)).to eq(user)
      expect(evaluator.instance_variable_get(:@badge)).to eq(badge)
    end
    
    it 'extracts criteria from badge' do
      criteria = { 'type' => 'lesson' }
      badge = create(:badge, criteria: criteria)
      evaluator = described_class.new(user: user, badge: badge)
      
      expect(evaluator.instance_variable_get(:@criteria)).to eq(criteria)
    end
    
    it 'handles nil criteria gracefully' do
      badge = create(:badge, criteria: nil)
      evaluator = described_class.new(user: user, badge: badge)
      
      expect(evaluator.instance_variable_get(:@criteria)).to eq({})
    end
  end
end