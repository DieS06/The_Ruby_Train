import React, { useMemo } from "react";
import { visit } from "@hotwired/turbo"
import type { ContentUnit } from "@/types/Content/ContentUnit"
import type { LessonUnit } from "@/types/Content/LessonUnit"
import { useCourseNavigator } from "./useCourseNavigator";

const flatten = (u?: ContentUnit): LessonUnit[] =>
  u ? (u.type === "LessonUnit" ? [u as LessonUnit] : u.children?.flatMap(flatten) ?? []) : []

function useLessonNavigator(slug: string) {
  const { course, loading, error } = useCourseNavigator()
  const lessons = useMemo(() => flatten(course), [course])

  const { items, prev, next } = useMemo(() => {
    const idx  = lessons.findIndex((l) => l.slug === slug)
    const cur  = lessons[idx]
    const prev = lessons[idx - 1] ?? null
    const next = lessons[idx + 1] ?? null

    const arr = 
      cur
        ? [
            ...(prev ? [{ id: prev.id, title: prev.title, slug: prev.slug }] : []),
            { id: cur.id, title: cur.title, slug: cur.slug },
            ...(next ? [{ id: next.id, title: next.title, slug: next.slug }] : []),
          ]
        : []
    return { items: arr, prev, cur, next }
  }, [lessons, slug])

  const goToLesson = (s: string) => visit(`/content_units/${s}`)

  return {
    loading,
    error,
    items,
    prevLesson: prev,
    nextLesson: next,
    goToLesson,
  }
}

export { useLessonNavigator }
