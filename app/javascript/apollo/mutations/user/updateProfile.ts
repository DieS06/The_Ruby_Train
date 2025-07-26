import {gql} from "@apollo/client";

export const MY_PROFILE_QUERY = gql`
mutation updateProfile(
    bio: "Desarrollador Ruby on Rails",
    linkedin_url: "https://www.linkedin.com/in/johndoe",
    github_url: "https://github.com/johndoe",
    website_url: "https://johndoe.dev",
    location: "San José, Costa Rica",
    company_name: "The Ruby Train",
    job_title: "Developer"
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
    }
    errors
}
`;