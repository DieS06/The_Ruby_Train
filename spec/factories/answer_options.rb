FactoryBot.define do
  factory :answer_option do
    question { nil }
    text { "MyString" }
    correct { false }
    explanation { "MyText" }
    position { 1 }
  end
end
