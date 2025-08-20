FactoryBot.define do
  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }
    description { "A comprehensive topic covering important concepts and practical applications in software development." }
    state { "visible" }
    association :created_by, factory: :user

    trait :visible do
      state { "visible" }
    end

    trait :hidden do
      state { "hidden" }
    end

    trait :with_content_units do
      after(:create) do |topic|
        create_list(:content_topic, 2, topic: topic)
      end
    end

    # Specific programming topics
    factory :programming_topic do
      sequence(:name) { |n| "Programming Concept #{n}" }
      description { "Essential programming concepts that every developer should master." }
    end

    factory :ruby_topic do
      name { "Ruby Programming" }
      description { "Ruby language fundamentals, syntax, and best practices." }
    end

    factory :rails_topic do
      name { "Ruby on Rails" }
      description { "Web application development with Ruby on Rails framework." }
    end
  end
end
