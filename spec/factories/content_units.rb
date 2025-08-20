FactoryBot.define do
  factory :content_unit do
    sequence(:title) { |n| "Content Unit #{n}" }
    sequence(:slug) { |n| "content-unit-#{n}" }
    description { "This is a comprehensive description for the content unit that meets the minimum length requirement." }
    position { 1 }
    lock_expire_at { 1.week.from_now }
    state { "published" }
    association :created_by, factory: :user
    parent { nil }

    trait :draft do
      state { "draft" }
    end

    trait :archived do
      state { "archived" }
    end

    trait :deleted do
      state { "deleted" }
      deleted_at { Time.current }
    end

    trait :visible do
      state { "visible" }
    end

    trait :hidden do
      state { "hidden" }
    end

    trait :with_topics do
      after(:create) do |content_unit|
        create_list(:content_topic, 2, content_unit: content_unit)
      end
    end

    # Course - top level, no parent
    factory :course do
      type { "Course" }
      sequence(:title) { |n| "Course #{n}" }
      sequence(:slug) { |n| "course-#{n}" }
      parent { nil }
    end

    # Module - belongs to Course
    factory :module_unit do
      type { "Module" }
      sequence(:title) { |n| "Module #{n}" }
      sequence(:slug) { |n| "module-#{n}" }
      association :parent, factory: :course
    end

    # Segment - belongs to Module
    factory :segment do
      type { "Segment" }
      sequence(:title) { |n| "Segment #{n}" }
      sequence(:slug) { |n| "segment-#{n}" }
      association :parent, factory: :module_unit
    end

    # Lesson - belongs to Segment
    factory :lesson do
      type { "Lesson" }
      sequence(:title) { |n| "Lesson #{n}" }
      sequence(:slug) { |n| "lesson-#{n}" }
      association :parent, factory: :segment
    end

    # Trait for creating full hierarchy
    trait :with_full_hierarchy do
      after(:create) do |content_unit|
        if content_unit.type == "Course"
          module_unit = create(:module_unit, parent: content_unit)
          segment = create(:segment, parent: module_unit)
          create(:lesson, parent: segment)
        end
      end
    end
  end
end
