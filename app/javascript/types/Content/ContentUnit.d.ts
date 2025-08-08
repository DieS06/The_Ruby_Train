import { Evaluation } from "./Evaluation";

interface ContentUnit {
  id: string;
  title: string;
  slug: string;
  type: string;
  state?: string;
  description?: string;
  position?: number;
  children?: ContentUnit[];
  quizzes?: Evaluation[];
  exams?: Evaluation[];
  finalExams?: Evaluation[];
}

type CourseUnit = Pick<ContentUnit, "id" | "title" | "slug" | "type"> & {
  children?: CourseUnit[];
};

export type { ContentUnit, CourseUnit };