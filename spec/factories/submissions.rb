FactoryBot.define do
  factory :submission do
    association :user
    association :evaluation
    submitted_at { Time.current }
    score { 85 }
    state { "submitted" }
    feedback { "Good work! You demonstrated strong understanding of the concepts covered in this evaluation." }

    trait :draft do
      state { "draft" }
      submitted_at { nil }
      score { nil }
    end

    trait :submitted do
      state { "submitted" }
      submitted_at { Time.current }
    end

    trait :graded do
      state { "graded" }
      submitted_at { 1.hour.ago }
      score { 88 }
      feedback { "Excellent work! You have mastered the key concepts. Minor areas for improvement noted." }
    end

    trait :perfect_score do
      score { 100 }
      feedback { "Perfect! Outstanding performance across all areas." }
    end

    trait :failing_score do
      score { 45 }
      feedback { "Needs improvement. Please review the material and consider retaking the evaluation." }
    end

    trait :high_score do
      score { 92 }
      feedback { "Excellent performance! You clearly understand the material very well." }
    end

    trait :average_score do
      score { 75 }
      feedback { "Good work! You have a solid understanding with room for improvement in some areas." }
    end

    trait :no_feedback do
      feedback { nil }
    end

    trait :with_answers do
      after(:create) do |submission|
        submission.evaluation.questions.each do |question|
          create(:submission_answer, submission: submission, question: question)
        end
      end
    end

    # Common submission scenarios
    factory :draft_submission, traits: [:draft]
    factory :completed_submission, traits: [:submitted, :with_answers]
    factory :graded_submission, traits: [:graded, :with_answers]
    factory :perfect_submission, traits: [:graded, :perfect_score, :with_answers]
  end
end
