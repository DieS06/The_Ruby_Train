FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:first_name) { |n| "User#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    sequence(:phone_number) { |n| "+1555000#{n.to_s.rjust(4, '0')}" }
    country { "United States" }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    state { "active" }
    confirmed_at { Time.current }
    
    after(:create) do |user|
      user.build_profile! unless user.profile.present?
    end

    trait :pending do
      state { "pending" }
      confirmed_at { nil }
    end

    trait :inactive do
      state { "inactive" }
    end

    trait :suspended do
      state { "suspended" }
    end

    trait :with_super_admin_role do
      after(:create) { |user| user.add_role(:super_admin) }
    end

    trait :with_admin_role do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :with_academy_role do
      after(:create) { |user| user.add_role(:academy) }
    end

    trait :with_mentor_role do
      after(:create) { |user| user.add_role(:mentor) }
    end

    trait :with_student_role do
      after(:create) { |user| user.add_role(:student) }
    end

    trait :invited do
      invitation_token { SecureRandom.hex(16) }
      invitation_created_at { Time.current }
      invitation_sent_at { Time.current }
      state { "pending" }
      confirmed_at { nil }
    end

    trait :with_profile do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end

    # Specific role factories
    factory :super_admin, traits: [:with_super_admin_role]
    factory :admin, traits: [:with_admin_role]
    factory :academy, traits: [:with_academy_role]
    factory :mentor, traits: [:with_mentor_role]
    factory :student, traits: [:with_student_role]
  end
end
