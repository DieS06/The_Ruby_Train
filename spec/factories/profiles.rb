FactoryBot.define do
  factory :profile do
    bio { "MyText" }
    linkedin_url { "MyString" }
    github_url { "MyString" }
    website_url { "MyString" }
    location { "MyString" }
    company_name { "MyString" }
    job_title { "MyString" }
    user { nil }
  end
end
