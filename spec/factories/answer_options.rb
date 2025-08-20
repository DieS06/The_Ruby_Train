FactoryBot.define do
  factory :answer_option do
    association :question
    sequence(:text) { |n| "Answer option #{n}" }
    correct { false }
    explanation { "Detailed explanation for why this answer is correct or incorrect." }
    position { 1 }

    trait :correct do
      correct { true }
      text { "This is the correct answer" }
      explanation { "This answer is correct because it accurately addresses the question requirements." }
    end

    trait :incorrect do
      correct { false }
      text { "This is an incorrect answer" }
      explanation { "This answer is incorrect because it does not meet the question criteria." }
    end

    trait :without_explanation do
      explanation { nil }
    end

    trait :true_option do
      text { "True" }
      correct { true }
    end

    trait :false_option do
      text { "False" }
      correct { false }
    end

    # Specific factories for common answer patterns
    factory :correct_answer, traits: [:correct]
    factory :incorrect_answer, traits: [:incorrect]
    factory :true_answer, traits: [:true_option]
    factory :false_answer, traits: [:false_option]
  end
end
