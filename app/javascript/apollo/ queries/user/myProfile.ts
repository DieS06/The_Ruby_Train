import {gql} from "@apollo/client";

export const MY_PROFILE_QUERY = gql`
query myProfile {
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
    }
}
`;