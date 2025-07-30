import { gql } from "@apollo/client";

export const FIND_LESSON_BY_SLUG = gql`
  query FindLessonBySlug($slug: String!) {
    findContentUnit(slug: $slug) {
      id
      title
      slug
      type
      description
      ... on LessonUnitType {
        id
        videoUrl
        imageUrl
        content
      }
    }
  }
`;
