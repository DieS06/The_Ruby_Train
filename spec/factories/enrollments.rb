FactoryBot.define do
  factory :enrollment do
    association :user
    association :content_unit, factory: :course
    enrolled_at { Time.current }
    state { "active" }
    progress_percent { 25.0 }

    trait :active do
      state { "active" }
      enrolled_at { Time.current }
    end

    trait :completed do
      state { "completed" }
      progress_percent { 100.0 }
      enrolled_at { 1.month.ago }
    end

    trait :suspended do
      state { "suspended" }
    end

    trait :dropped do
      state { "dropped" }
    end

    trait :just_started do
      progress_percent { 0.0 }
      enrolled_at { Time.current }
    end

    trait :halfway do
      progress_percent { 50.0 }
      enrolled_at { 2.weeks.ago }
    end

    trait :almost_complete do
      progress_percent { 95.0 }
      enrolled_at { 1.month.ago }
    end

    trait :with_progress do
      after(:create) do |enrollment|
        create(:progress, user: enrollment.user, content_unit: enrollment.content_unit)
      end
    end

    # Common enrollment scenarios
    factory :new_enrollment, traits: [:active, :just_started]
    factory :completed_enrollment, traits: [:completed, :with_progress]
    factory :active_enrollment, traits: [:active, :halfway, :with_progress]
  end
end
