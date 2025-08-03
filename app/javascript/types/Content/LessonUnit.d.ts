import type { ContentUnit } from "./ContentUnit"

export interface LessonUnit extends ContentUnit {
  type: "LessonUnit"
  imageUrl?: string | null
  videoUrl?: string | null
  richBodyHtml?: string | null
  nextSlug?: string | null
  previousSlug?: string | null
}
