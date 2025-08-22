import { gql } from "@apollo/client";

export const FIND_LESSON_NAV = gql`
  query FindLessonNav($slug: String!) {
    findLessonNav(slug: $slug) {
      items { id title slug }
      currentIndex
      quizId
    }
  }
`;
