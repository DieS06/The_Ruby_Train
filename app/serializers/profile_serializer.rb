class ProfileSerializer < ActiveModel::Serializer
  attributes :bio, :location, :company_name, :job_title,
             :profile_urls

  def profile_urls
    {
      linkedin_url: object.linkedin_url,
      github_url: object.github_url,
      website_url: object.website_url
    }
  end
end
