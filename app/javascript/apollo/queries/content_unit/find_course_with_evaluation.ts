import { gql } from "@apollo/client";

export const FIND_COURSE_WITH_EVALUATIONS = gql`
  query FindCourseWithEvaluations($slug: String!) {
    findContentUnitWithHierarchy(
      type: "Course"
      slug: $slug
      direction: "DESC"
    ) {
      ... on CourseUnitType {
        id
        title
        slug
        children {
          id
          title
          slug
          position
          ... on ModuleUnitType {
            exams {
              id
              title
            }
            children {
              id
              title
              slug
              position
              ... on SegmentUnitType {
                quizzes {
                  id
                  title
                }
                children {
                  id
                  title
                  slug
                  position
                }
              }
            }
          }
        }
      }
    }
  }
`;
