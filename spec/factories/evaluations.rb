FactoryBot.define do
  factory :evaluation do
    sequence(:title) { |n| "Evaluation #{n}" }
    description { "This is a comprehensive evaluation description that tests knowledge and understanding." }
    time_limit { 60 }
    state { "active" }
    association :content_unit, factory: :lesson
    association :creator, factory: :user

    trait :draft do
      state { "draft" }
    end

    trait :archived do
      state { "archived" }
    end

    trait :hidden do
      state { "hidden" }
    end

    trait :visible do
      state { "visible" }
    end

    trait :with_questions do
      after(:create) do |evaluation|
        create_list(:question, 3, evaluation: evaluation)
      end
    end

    trait :with_settings do
      after(:create) do |evaluation|
        create(:evaluation_setting, evaluation: evaluation)
      end
    end

    trait :with_sections do
      after(:create) do |evaluation|
        create_list(:evaluation_section, 2, evaluation: evaluation)
      end
    end

    # Quiz - specific type
    factory :quiz do
      type { "Quiz" }
      sequence(:title) { |n| "Quiz #{n}" }
      time_limit { 30 }
    end

    # Exam - specific type
    factory :exam do
      type { "Exam" }
      sequence(:title) { |n| "Exam #{n}" }
      time_limit { 120 }
    end

    # Specific evaluation types with content
    factory :quiz_with_questions, traits: [:with_questions] do
      type { "Quiz" }
    end

    factory :exam_with_questions, traits: [:with_questions] do
      type { "Exam" }
    end
  end
end
