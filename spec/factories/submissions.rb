FactoryBot.define do
  factory :submission do
    user { nil }
    evaluation { nil }
    submitted_at { "2025-07-10 15:04:49" }
    score { 1 }
    state { 1 }
    feedback { "MyText" }
  end
end
