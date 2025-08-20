# frozen_string_literal: true

# == BadgeCriteriaEvaluator
#
# Evaluates whether a user satisfies the requirements to earn a specific badge.
# Uses both Progress and Submission data to determine eligibility.
#

class BadgeCriteriaEvaluator
  def initialize(user:, badge:)
    @user = user
    @badge = badge
    @criteria = badge.criteria || {}
  end

  def satisfied?
    case @criteria["type"]
    when "lesson"
      lesson_with_quiz_completed?
    when "segment"
      segment_completed_with_quiz?
    when "module"
      module_completed_with_exam?
    when "quiz"
      quiz_score_met?
    when "exam"
      exam_score_met?
    when "silver"
      completed_all_course?
    when "trophy"
      trophy_conditions_met?
    else
      false
    end
  end

  private

  def lesson_with_quiz_completed?
    lesson_id = @criteria.dig("conditions", "lesson_id")
    progress = @user.progresses.find_by(content_unit_id: lesson_id)
    progress&.passed? && progress.score.to_i >= 100
  end

  def segment_completed_with_quiz?
    segment_id = @criteria.dig("conditions", "segment_id")
    lessons = ContentUnit.where(parent_id: segment_id, type: "LessonUnit")
    progresses = @user.progresses.where(content_unit_id: lessons, state: :passed)

    return false if progresses.count < lessons.count

    quiz = Evaluation.find_by(content_unit_id: segment_id, type: "Quiz")
    return false unless quiz

    last_submission = quiz.submissions.where(user: @user, state: :graded).order(created_at: :desc).first
    last_submission&.score.to_i >= 80
  end

  def module_completed_with_exam?
    module_id = @criteria.dig("conditions", "module_id")
    segments = ContentUnit.where(parent_id: module_id, type: "SegmentUnit")
    lessons = ContentUnit.where(parent_id: segments.pluck(:id), type: "LessonUnit")

    progresses = @user.progresses.where(content_unit_id: lessons, state: :passed)
    return false if progresses.count < lessons.count

    exam = Evaluation.find_by(content_unit_id: module_id, type: "Exam")
    return false unless exam

    last_submission = exam.submissions.where(user: @user, state: :graded).order(created_at: :desc).first
    last_submission&.score.to_i >= 80
  end

  def quiz_score_met?
    evaluation_id = @criteria.dig("conditions", "evaluation_id")
    quiz = Evaluation.find_by(id: evaluation_id, type: "Quiz")
    return false unless quiz

    last_submission = quiz.submissions.where(user: @user, state: :graded).order(created_at: :desc).first
    last_submission&.score.to_i >= 80
  end

  def exam_score_met?
    evaluation_id = @criteria.dig("conditions", "evaluation_id")
    exam = Evaluation.find_by(id: evaluation_id, type: "Exam")
    return false unless exam

    last_submission = exam.submissions.where(user: @user, state: :graded).order(created_at: :desc).first
    last_submission&.score.to_i >= 80
  end

  def completed_all_course?
    lessons = ContentUnit.where(type: "LessonUnit")
    total_required = lessons.count
    return false if total_required.zero?

    completed = @user.progresses.where(content_unit_id: lessons, state: :passed)
    return false unless completed.count == total_required

    final_exam = Evaluation.where(type: "Exam").order(created_at: :desc).last
    return false unless final_exam

    final_score = final_exam.submissions.where(user: @user, state: :graded).order(created_at: :desc).pluck(:score).first
    final_score.to_i >= 80
  end

  def trophy_conditions_met?
    tag = @criteria.dig("conditions", "tag")
    required_count = @criteria.dig("conditions", "count").to_i

    case tag
    when "perfect_quizzes"
      quizzes = Evaluation.where(type: "Quiz")
      passed = quizzes.select do |quiz|
        quiz.submissions.where(user: @user, state: :graded).order(created_at: :desc).first&.score.to_i == 100
      end
      passed.count >= required_count
    when "perfect_exams"
      exams = Evaluation.where(type: "Exam")
      passed = exams.select do |exam|
        exam.submissions.where(user: @user, state: :graded).order(created_at: :desc).first&.score.to_i == 100
      end
      passed.count >= required_count
    else
      false
    end
  end
end
