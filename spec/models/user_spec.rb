require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

# spec/factories/users.rb
factory :user do
  email    { Faker::Internet.unique.email }
  password { 'Password123!' }
end

# spec/factories/content_units.rb
factory :content_unit, class: 'ContentUnit::CourseUnit' do
  title       { Faker::Educator.course_name }
  slug        { Faker::Internet.slug }
  type        { 'ContentUnit::CourseUnit' }      # STI
  created_by  { association :user }
end

# spec/factories/groups.rb
factory :group do
  name        { Faker::Company.name }
  created_by  { association :user }
end
end
