import { gql } from '@apollo/client';

export const GET_USERS = gql`
  query GetUsers($page: Int, $perPage: Int) {
    users(page: $page, perPage: $perPage) {
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
`;