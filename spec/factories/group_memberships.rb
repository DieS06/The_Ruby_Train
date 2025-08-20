FactoryBot.define do
  factory :group_membership do
    association :group
    association :user
    association :inviter, factory: :user
    joined_at { Time.current }
    role_in_group { "member" }
    state { "active" }

    trait :member_role do
      role_in_group { "member" }
    end

    trait :assistant_role do
      role_in_group { "assistant" }
    end

    trait :mentor_role do
      role_in_group { "mentor" }
    end

    trait :coordinator_role do
      role_in_group { "coordinator" }
    end

    trait :student_role do
      role_in_group { "student" }
    end

    trait :invited do
      state { "invited" }
      invited_token { SecureRandom.hex(16) }
      joined_at { nil }
    end

    trait :active do
      state { "active" }
      joined_at { Time.current }
    end

    trait :archived do
      state { "archived" }
    end

    trait :draft do
      state { "draft" }
      joined_at { nil }
    end

    # Specific role factories for common use cases
    factory :student_membership do
      role_in_group { "student" }
      state { "active" }
    end

    factory :mentor_membership do
      role_in_group { "mentor" }
      state { "active" }
    end

    factory :invited_membership do
      state { "invited" }
      invited_token { SecureRandom.hex(16) }
      joined_at { nil }
    end
  end
end
