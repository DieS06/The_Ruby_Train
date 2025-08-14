import {gql} from "@apollo/client/core";

export const MY_PROFILE_QUERY = gql`
query MyProfile {
  myProfile {
    id
    bio
	  linkedinUrl
    githubUrl
    websiteUrl
    location
    companyName
    jobTitle
    userId
    createdAt
    updatedAt
    user {
      email
			first_name
			last_name
			phone_number
			state
			country
			roleNames
      updated_at
    }
  }
}
`;