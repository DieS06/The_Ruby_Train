# frozen_string_literal: true

# == ProfileSerializer
#
# Serialize {Profile}.
#
# === JSON Attributes
# * id, bio, location, company_name, job_title,
# * profile_urls (nested attributes, linkedin_url, github_url, website_url)
#

class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :bio, :location, :company_name, :job_title,
             :profile_urls

  def profile_urls
    {
      linkedin_url: object.linkedin_url,
      github_url: object.github_url,
      website_url: object.website_url
    }
  end
end
