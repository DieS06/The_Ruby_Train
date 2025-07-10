FactoryBot.define do
  factory :question do
    evaluation { nil }
    evaluation_section { nil }
    text { "MyText" }
    question_type { 1 }
    position { 1 }
    explanation { "MyText" }
    points { 1 }
  end
end
