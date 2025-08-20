FactoryBot.define do
  factory :content_topic do
    content_unit { nil }
    topic { nil }
    relevance { 1 }
    state { 1 }
  end
end
