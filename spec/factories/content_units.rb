FactoryBot.define do
  factory :content_unit do
    type { "" }
    parent_id { "" }
    title { "MyString" }
    slug { "MyString" }
    state { 1 }
    description { "MyText" }
    position { 1 }
    lock_expire_at { "2025-07-09 07:28:10" }
    created_by { "" }
  end
end
