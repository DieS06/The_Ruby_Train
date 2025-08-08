import { gql } from "@apollo/client";

export const GET_QUESTIONS = gql`
  query GetQuestions($contentUnitId: ID!, $topicId: ID) {
    questions(contentUnitId: $contentUnitId, topicId: $topicId) {
      id
      evaluationId
      evaluationSectionId
      topicId
      statement
      questionType
      position
      explanation
      points
      createdAt
      updatedAt
      createdBy
    }
  }
`;
