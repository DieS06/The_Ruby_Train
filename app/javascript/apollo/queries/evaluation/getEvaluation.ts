import { gql } from "@apollo/client";

const GET_EVALUATION = gql`
  query GetEvaluation($id: ID!) {
    evaluation(id: $id) {
        id
        type
        title
        description
        timeLimit
        state
        createdBy
        createdAt
        updatedAt
        contentUnitId
        contentUnit {
          id
          type
          parentId
          title
          slug
          state
          description
          position
          createdBy
          createdAt
          updatedAt
        }
    }
  }
`;

export { GET_EVALUATION };
