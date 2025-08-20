FactoryBot.define do
  factory :evaluation_setting do
    evaluation { nil }
    attempts_allowed { 1 }
    shuffle_questions { false }
    show_results { false }
    show_feedback { false }
    config { "" }
  end
end
