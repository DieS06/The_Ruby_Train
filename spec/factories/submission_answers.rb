FactoryBot.define do
  factory :submission_answer do
    submission { nil }
    question { nil }
    answer_option { nil }
    text_answer { "MyText" }
    correct { false }
  end
end
