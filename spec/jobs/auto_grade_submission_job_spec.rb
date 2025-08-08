# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutoGradeSubmissionJob, type: :job do
  let(:evaluation) { create(:evaluation) }
  let(:submission) { create(:submission, evaluation: evaluation) }
  let(:question1) { create(:question, evaluation: evaluation, points: 10) }
  let(:question2) { create(:question, evaluation: evaluation, points: 15) }

  describe '#perform' do
    let!(:answer1) { create(:submission_answer, submission: submission, question: question1) }
    let!(:answer2) { create(:submission_answer, submission: submission, question: question2) }

    before do
      allow(answer1).to receive(:auto_grade!)
      allow(answer2).to receive(:auto_grade!)
      allow(answer1).to receive(:is_correct).and_return(true)
      allow(answer2).to receive(:is_correct).and_return(false)
      allow(answer1).to receive(:question_points).and_return(10)
      allow(answer2).to receive(:question_points).and_return(0)

      allow(submission).to receive(:submission_answers).and_return([ answer1, answer2 ])
      allow(submission.submission_answers).to receive(:includes).with(:question, :answer_option).and_return([ answer1, answer2 ])
      allow(submission.submission_answers).to receive(:where).with(is_correct: true).and_return([ answer1 ])
    end

    it 'processes the submission with the given ID' do
      expect(Submission).to receive(:find).with(submission.id).and_return(submission)

      described_class.perform_now(submission.id)
    end

    it 'calls auto_grade! on each submission answer' do
      described_class.perform_now(submission.id)

      expect(answer1).to have_received(:auto_grade!)
      expect(answer2).to have_received(:auto_grade!)
    end

    it 'includes question and answer_option associations for performance' do
      expect(submission.submission_answers).to receive(:includes).with(:question, :answer_option)

      described_class.perform_now(submission.id)
    end

    it 'calculates and updates the submission score' do
      allow(submission.submission_answers.where(is_correct: true)).to receive(:sum).and_return(10)

      expect(submission).to receive(:update!).with(
        score: 10,
        graded: true,
        submitted_at: kind_of(Time)
      )

      described_class.perform_now(submission.id)
    end

    it 'marks submission as graded' do
      expect(submission).to receive(:update!).with(
        hash_including(graded: true)
      )

      described_class.perform_now(submission.id)
    end

    it 'sets submitted_at to current time' do
      freeze_time do
        expect(submission).to receive(:update!).with(
          hash_including(submitted_at: Time.current)
        )

        described_class.perform_now(submission.id)
      end
    end

    it 'wraps the operation in a transaction' do
      expect(Submission).to receive(:transaction).and_yield

      described_class.perform_now(submission.id)
    end

    context 'when submission is not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          described_class.perform_now(99999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with real submission and answers' do
      let!(:question) { create(:question, evaluation: evaluation, points: 20) }
      let!(:correct_option) { create(:answer_option, question: question, is_correct: true) }
      let!(:incorrect_option) { create(:answer_option, question: question, is_correct: false) }
      let!(:correct_answer) { create(:submission_answer, submission: submission, question: question, answer_option: correct_option) }

      it 'actually grades the submission' do
        expect {
          described_class.perform_now(submission.id)
        }.to change { submission.reload.graded }.from(false).to(true)
      end

      it 'calculates the correct score' do
        described_class.perform_now(submission.id)

        expect(submission.reload.score).to eq(20)
      end

      it 'sets the submitted_at timestamp' do
        expect {
          described_class.perform_now(submission.id)
        }.to change { submission.reload.submitted_at }.from(nil).to(kind_of(Time))
      end
    end

    context 'with multiple questions and mixed answers' do
      let!(:q1) { create(:question, evaluation: evaluation, points: 10) }
      let!(:q2) { create(:question, evaluation: evaluation, points: 15) }
      let!(:q3) { create(:question, evaluation: evaluation, points: 20) }

      let!(:correct_option_q1) { create(:answer_option, question: q1, is_correct: true) }
      let!(:incorrect_option_q2) { create(:answer_option, question: q2, is_correct: false) }
      let!(:correct_option_q3) { create(:answer_option, question: q3, is_correct: true) }

      let!(:answer_q1) { create(:submission_answer, submission: submission, question: q1, answer_option: correct_option_q1) }
      let!(:answer_q2) { create(:submission_answer, submission: submission, question: q2, answer_option: incorrect_option_q2) }
      let!(:answer_q3) { create(:submission_answer, submission: submission, question: q3, answer_option: correct_option_q3) }

      it 'calculates partial score correctly' do
        described_class.perform_now(submission.id)

        # Should score 10 + 0 + 20 = 30 points
        expect(submission.reload.score).to eq(30)
      end
    end
  end

  describe 'job configuration' do
    it 'is queued on default queue' do
      expect(described_class.queue_name).to eq('default')
    end

    it 'inherits from ApplicationJob' do
      expect(described_class.superclass).to eq(ApplicationJob)
    end
  end
end
