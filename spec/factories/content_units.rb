# spec/factories/content_units.rb
FactoryBot.define do
  factory :content_unit do
    sequence(:title) { |n| "Sample Title #{n}" }
    sequence(:slug) { |n| "sample-title-#{n}" }
    description { "This is a valid description." }
    position { 1 }
    lock_expire_at { 1.week.from_now }
    created_by { 1 }

    trait :course do
      type { "Course" }
    end

    trait :module do
      type { "Module" }
    end

    trait :segment do
      type { "Segment" }
    end

    trait :lesson do
      type { "Lesson" }
    end

    factory :course, traits: [ :course ]
    factory :module_unit, traits: [ :module ]
    factory :segment, traits: [ :segment ]
    factory :lesson, traits: [ :lesson ]
  end
end
