import React from "react";

import { useQuery } from "@apollo/client";
import { FIND_LESSON_BY_SLUG } from "../../apollo/queries/content_unit/find_lesson_by_slug";
import { LessonViewer } from "@/bundles/components/ContentUnit/LessonVIewer";

export default function Lesson() {
  const slug = window.location.pathname.split("/").pop();
  const { data, loading, error } = useQuery(FIND_LESSON_BY_SLUG, {
    variables: { slug },
  });

  if (loading) return <p>Loading lesson...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return <LessonViewer lesson={data.findContentUnit} />;
}
