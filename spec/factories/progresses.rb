FactoryBot.define do
  factory :progress do
    association :user
    association :content_unit
    completed_at { nil }
    score { nil }
    state { "in_progress" }

    trait :in_progress do
      state { "in_progress" }
      completed_at { nil }
      score { nil }
    end

    trait :completed do
      state { "completed" }
      completed_at { Time.current }
      score { 85 }
    end

    trait :failed do
      state { "failed" }
      completed_at { Time.current }
      score { 45 }
    end

    trait :perfect_score do
      state { "completed" }
      completed_at { Time.current }
      score { 100 }
    end

    trait :high_score do
      state { "completed" }
      completed_at { Time.current }
      score { 92 }
    end

    trait :just_passed do
      state { "completed" }
      completed_at { Time.current }
      score { 70 }
    end

    trait :lesson_progress do
      association :content_unit, factory: :lesson
    end

    trait :course_progress do
      association :content_unit, factory: :course
    end

    # Common progress scenarios
    factory :lesson_completed, traits: [:lesson_progress, :completed]
    factory :course_completed, traits: [:course_progress, :completed]
    factory :perfect_lesson, traits: [:lesson_progress, :perfect_score]
  end
end
