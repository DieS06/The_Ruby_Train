FactoryBot.define do
  factory :enrollment do
    user { nil }
    content_unit { nil }
    enrolled_at { "2025-07-09 21:03:08" }
    state { 1 }
    progress_percent { "9.99" }
  end
end
