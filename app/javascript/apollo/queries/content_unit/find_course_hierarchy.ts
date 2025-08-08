import { gql } from "@apollo/client";

export const FIND_COURSE_HIERARCHY = gql`
  query {
    findContentUnitWithHierarchy(type: "Course", slug: "ruby-silver", direction: DESC) {
      ... on CourseUnit {
        id title slug type state description position
        finalExams {id title timeLimit state}
        children {
          ... on ModuleUnit {
            id title slug type state description position
            exams {id title timeLimit state}
            children {
              ... on SegmentUnit {
                id title slug type state description position
                quizzes {id title timeLimit state}
                children {
                  ... on LessonUnit {
                    id title slug type state description position
                    quizzes {id title timeLimit state}
                  }
                }
              }
            }
          }
        }
      }
    }
  }
`;
