FactoryBot.define do
  factory :profile do
    bio { "Experienced software developer passionate about creating innovative solutions and learning new technologies." }
    linkedin_url { "https://linkedin.com/in/johndoe" }
    github_url { "https://github.com/johndoe" }
    website_url { "https://johndoe.dev" }
    location { "San José, Costa Rica" }
    company_name { "Tech Solutions Inc." }
    job_title { "Senior Software Developer" }
    association :user

    trait :minimal do
      bio { "New user profile" }
      linkedin_url { "" }
      github_url { "" }
      website_url { "" }
      location { "Costa Rica" }
      company_name { "" }
      job_title { "" }
    end

    trait :complete do
      bio { "Highly experienced full-stack developer with over 10 years in the industry, specialized in Ruby on Rails, React, and modern web technologies. Passionate about clean code and agile methodologies." }
      linkedin_url { "https://linkedin.com/in/johndoesenior" }
      github_url { "https://github.com/johndoesenior" }
      website_url { "https://johndoesenior.dev" }
      location { "San José, Costa Rica" }
      company_name { "Innovation Labs Costa Rica" }
      job_title { "Lead Software Architect" }
    end

    trait :student_profile do
      bio { "Computer Science student eager to learn and grow in software development." }
      linkedin_url { "https://linkedin.com/in/studentjohn" }
      github_url { "https://github.com/studentjohn" }
      website_url { "" }
      location { "Cartago, Costa Rica" }
      company_name { "" }
      job_title { "Computer Science Student" }
    end
  end
end
