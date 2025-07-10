FactoryBot.define do
  factory :evaluation do
    type { "" }
    title { "MyString" }
    description { "MyText" }
    time_limit { 1 }
    state { 1 }
    content_unit { nil }
    created_by { "" }
  end
end
