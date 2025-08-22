class ProgressionPolicy
  PASS_THRESHOLD = 0.8

  # @return [Symbol] :locked, :ready_for_quiz, :quiz_unlocked, :exam_unlocked
  # plus extra data to render CTAs
  def self.for(user:, segment:)
    quizzes = segment.quizzes.order(:created_at)
    return { state: :ready_for_quiz } if quizzes.empty?

    latest_quiz = quizzes.last
    latest_sub  = latest_quiz.submissions.where(user: user).order(created_at: :desc).first
    return { state: :quiz_unlocked, evaluation_id: latest_quiz.id } unless latest_sub

    if latest_sub.score.to_i >= (latest_quiz.total_points * PASS_THRESHOLD).ceil
      { state: :exam_unlocked }
    else
      { state: :quiz_unlocked, evaluation_id: latest_quiz.id }
    end
  end
end
