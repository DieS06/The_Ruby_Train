import { gql } from '@apollo/client';

export const GET_MY_PROFILE = gql`
  query GetMyProfile {
    myProfile { 
      id
      bio
      linkedinUrl
      githubUrl
      websiteUrl
      location
      companyName
      jobTitle

      createdAt
      updatedAt

      user {
        id
        email
        firstName
        lastName
        country
        phoneNumber
        state

        createdAt
        updatedAt

        roleNames
        roles {
          id
          name
          resourceType
          resourceId
          createdAt
          updatedAt
        }
      }
    }
  }
`;