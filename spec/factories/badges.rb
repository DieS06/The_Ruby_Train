FactoryBot.define do
  factory :badge do
    sequence(:name) { |n| "Achievement Badge #{n}" }
    badge_type { "lesson" }
    three_d_model_url { "https://models.example.com/badge.glb" }
    criteria { { "type" => "complete_lesson", "lesson_id" => 1 } }
    state { "active" }

    trait :quiz_badge do
      badge_type { "quiz" }
      sequence(:name) { |n| "Quiz Master #{n}" }
      criteria { { "type" => "complete_quiz", "quiz_id" => 1, "min_score" => 80 } }
    end

    trait :module_badge do
      badge_type { "module" }
      sequence(:name) { |n| "Module Completion #{n}" }
      criteria { { "type" => "complete_module", "module_id" => 1 } }
    end

    trait :trophy_badge do
      badge_type { "trophy" }
      sequence(:name) { |n| "Course Champion #{n}" }
      criteria { { "type" => "complete_course", "course_id" => 1, "perfect_score" => true } }
    end

    trait :silver_badge do
      badge_type { "silver" }
      sequence(:name) { |n| "Silver Achievement #{n}" }
      criteria { { "type" => "streak_days", "days" => 30 } }
    end

    trait :inactive do
      state { "inactive" }
    end

    trait :awarded do
      state { "awarded" }
    end

    trait :visible do
      state { "visible" }
    end

    trait :hidden do
      state { "hidden" }
    end

    trait :with_complex_criteria do
      criteria do
        {
          "type" => "multiple_conditions",
          "conditions" => [
            { "type" => "complete_lessons", "count" => 5 },
            { "type" => "quiz_average", "min_score" => 85 },
            { "type" => "time_frame", "days" => 14 }
          ]
        }
      end
    end

    trait :without_3d_model do
      three_d_model_url { nil }
    end
  end
end
