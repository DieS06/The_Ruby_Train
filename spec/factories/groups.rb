FactoryBot.define do
  factory :group do
    name { "MyString" }
    description { "MyText" }
    group_type { 1 }
    mentor_id { "" }
    academic_id { "" }
    state { 1 }
  end
end
