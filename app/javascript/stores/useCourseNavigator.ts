import { useEffect } from "react"
import { useQuery } from "@apollo/client"
import { create } from "zustand"
import { FIND_COURSE_HIERARCHY } from "@/apollo/queries/content_unit/find_course_hierarchy"
import type { ContentUnit } from "@/types/Content/ContentUnit"

interface StoreState {
  course?: ContentUnit
  setCourse: (c: ContentUnit) => void
}
const useStore = create<StoreState>((set) => ({
  course: undefined,
  setCourse: (course) => set({ course }),
}))

export function useCourseNavigator() {
  const { course, setCourse } = useStore()
  const { data, loading, error } = useQuery(FIND_COURSE_HIERARCHY, { skip: Boolean(course) })

  useEffect(() => {
    if (data?.findContentUnitWithHierarchy && !course) {
      setCourse(data.findContentUnitWithHierarchy)
    }
  }, [data, course, setCourse])

  return { course, loading: loading && !course, error }
}
