import { gql } from "@apollo/client";

export const FIND_LESSON_BY_SLUG = gql`
  query FindLessonBySlug($slug: String!) {
    findLessonWithExtras(
      slug: $slug
    ) {
      id
      title
      slug
      type
      description
      ... on LessonUnit {
        videoUrl
        imageUrl
        richBody
        nextSlug
      }
    }
  }
`;
