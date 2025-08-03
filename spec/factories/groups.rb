FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Learning Group #{n}" }
    description { "A comprehensive learning group focused on software development skills and practical application." }
    group_type { "mentor_group" }
    state { "open" }
    association :mentor, factory: :user
    association :academic, factory: :user
    association :created_by, factory: :user

    trait :academic_group do
      group_type { "academic_group" }
      sequence(:name) { |n| "Academic Group #{n}" }
      description { "Academic-focused group for theoretical learning and academic support." }
    end

    trait :other_group do
      group_type { "other" }
      sequence(:name) { |n| "Special Interest Group #{n}" }
      description { "Special interest group for specific topics or activities." }
    end

    trait :active do
      state { "active" }
    end

    trait :closed do
      state { "closed" }
    end

    trait :archived do
      state { "archived" }
    end

    trait :deleted do
      state { "deleted" }
      deleted_at { Time.current }
    end

    trait :with_members do
      after(:create) do |group|
        create_list(:group_membership, 3, group: group, role_in_group: "student")
        create(:group_membership, group: group, user: group.mentor, role_in_group: "mentor") if group.mentor
      end
    end

    trait :with_courses do
      after(:create) do |group|
        create_list(:group_course, 2, group: group)
      end
    end

    trait :full_setup do
      with_members
      with_courses
      active
    end
  end
end
