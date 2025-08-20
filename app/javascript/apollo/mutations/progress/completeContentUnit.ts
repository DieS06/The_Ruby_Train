import { gql } from "@apollo/client";

export const COMPLETE_CONTENT_UNIT = gql`
  mutation CompleteContentUnit($id: ID!) {
    completeContentUnit(id: $id) {
      courseCompletion      # ← % global del curso
    }
  }
`;
