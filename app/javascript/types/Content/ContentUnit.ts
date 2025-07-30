interface ContentUnit {
  id: string;
  title: string;
  slug: string;
  type: string;
  state?: string;
  description?: string;
  position?: number;
  children?: ContentUnit[];
}

type CourseUnit = Pick<ContentUnit, "id" | "title" | "slug" | "type"> & {
  children?: CourseUnit[];
};

export type { ContentUnit, CourseUnit };