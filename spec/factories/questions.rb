FactoryBot.define do
  factory :question do
    association :evaluation
    association :evaluation_section, factory: :evaluation_section, strategy: :build
    association :topic, strategy: :build
    association :creator, factory: :user
    sequence(:statement) { |n| "What is the correct answer for question #{n}? Please select the most appropriate option." }
    question_type { "single_choice" }
    position { 1 }
    explanation { "This explanation provides context and reasoning for the correct answer to help students understand the concept better." }
    points { 10 }

    trait :single_choice do
      question_type { "single_choice" }
      after(:create) do |question|
        create(:answer_option, question: question, text: "Correct answer", correct: true)
        create_list(:answer_option, 3, question: question, correct: false)
      end
    end

    trait :multiple_choice do
      question_type { "multiple_choice" }
      after(:create) do |question|
        create_list(:answer_option, 2, question: question, correct: true)
        create_list(:answer_option, 2, question: question, correct: false)
      end
    end

    trait :true_false do
      question_type { "true_false" }
      statement { "Ruby is an object-oriented programming language. True or False?" }
      after(:create) do |question|
        create(:answer_option, question: question, text: "True", correct: true)
        create(:answer_option, question: question, text: "False", correct: false)
      end
    end

    trait :text_input do
      question_type { "text_input" }
      statement { "Explain the difference between a class and an object in object-oriented programming." }
    end

    trait :with_high_points do
      points { 25 }
    end

    trait :with_low_points do
      points { 5 }
    end

    trait :without_explanation do
      explanation { nil }
    end

    trait :without_section do
      evaluation_section { nil }
    end

    trait :without_topic do
      topic { nil }
    end

    # Specific question types for common use
    factory :single_choice_question, traits: [:single_choice]
    factory :multiple_choice_question, traits: [:multiple_choice]
    factory :true_false_question, traits: [:true_false]
    factory :text_input_question, traits: [:text_input]
  end
end
