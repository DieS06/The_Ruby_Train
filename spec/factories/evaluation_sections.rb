FactoryBot.define do
  factory :evaluation_section do
    evaluation { nil }
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    time_limit { 1 }
  end
end
