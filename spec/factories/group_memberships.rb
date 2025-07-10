FactoryBot.define do
  factory :group_membership do
    group { nil }
    user { nil }
    joined_at { "2025-07-09 15:48:20" }
    role_in_group { 1 }
    invited_by { "" }
    invited_token { "MyString" }
    state { 1 }
  end
end
