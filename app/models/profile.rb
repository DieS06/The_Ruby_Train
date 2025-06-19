class Profile < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :linkedin_url, :github_url, :website_url,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[https]),
            message: "Must be a valid URL" }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :location, length: { maximum: 100 }, allow_blank: true
  validates :company_name, length: { maximum: 100 }, allow_blank: true
  validates :job_title, length: { maximum: 100 }, allow_blank: true
end
