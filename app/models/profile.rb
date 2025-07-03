# frozen_string_literal: true

# == Profile
#
# @!group 01-Models / Users
#
# Public date of {User}. Includes socialmedia link and
# professional details.
#
# === Attributes
# @!attribute [rw] bio
#   @return [String] Brief presentation (max. 500 char.)
# @!attribute [rw] location
#   @return [String] Users city/location.
# @!attribute [rw] company_name
#   @return [String] Actual company name.
# @!attribute [rw] job_title
#   @return [String] Job title in the actual company.
# @!attribute [rw] linkedin_url
#   @return [String] URL of personal LinkedIn.
# @!attribute [rw] github_url
#   @return [String] URL of personal GitHub.
# @!attribute [rw] website_url
#   @return [String] Personal website or portfolio.
#
# @example Update profile
#   profile.update!(bio: "Back-end Developer", location: "Cartago, Costa Rica")
#
# @!endgroup
#
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
