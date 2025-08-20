import {gql} from "@apollo/client";

export const UPDATE_PROFILE_MUTATION = gql`
mutation updateProfile(
       $bio: String
    $linkedin_url: String
    $github_url: String
    $website_url: String
    $location: String
    $company_name: String
    $job_title: String
  ) {
    updateProfile(
      bio: $bio
      linkedin_url: $linkedin_url
      github_url: $github_url
      website_url: $website_url
      location: $location
      company_name: $company_name
      job_title: $job_title
    ) {
      profile {
        id
        bio
        linkedinUrl
        githubUrl
        websiteUrl
        location
        companyName
        jobTitle
        updatedAt
      }
    errors
    }
  }
`;