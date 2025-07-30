import React from "react";
import DOMPurify from 'dompurify';
import {useCompleteContentUnit} from "@/stores/useCompleteContentUnit";
import type { ContentUnit } from "@/types/Content/ContentUnit";

interface Props {
  lesson: ContentUnit & {
    videoUrl?: string | null;
    imageUrl?: string | null;
    richBody?: string | null;
    nextSlug?: string | null;
  };
}

function LessonViewer({ lesson }: Props) {
    if (!lesson) return null;
    const { complete, loading } = useCompleteContentUnit();

   return (
    <article className="lesson-viewer">
      <header className="lesson-header">
        <h1 className="lesson-title">{lesson.title}</h1>
        {lesson.description && (
          <p className="lesson-description">{lesson.description}</p>
        )}
      </header>

      {lesson.videoUrl ? (
        <video
          className="lesson-video"
          controls
          src={lesson.videoUrl}
        />
      ) : (
        <div className="lesson-video-placeholder">
          <span>[ Video placeholder ]</span>
        </div>
      )}

      {lesson.imageUrl && (
        <img
          src={lesson.imageUrl}
          alt={lesson.title}
          className="lesson-image"
        />
      )}

      <section
        className="lesson-content"
        dangerouslySetInnerHTML={{
          __html: DOMPurify.sanitize(lesson.richBody ?? ""),
        }}
      />

      <footer className="lesson-footer">
        <button
          disabled={loading}
          className="btn-complete"
          onClick={() => complete(lesson.id)}
        >
          {loading ? "..." : "Mark as Completed"}
        </button>

        {lesson.nextSlug && (
          <a
            className="btn-next"
            href={`/content_units/${lesson.nextSlug}`}
          >
            Next&nbsp;›
          </a>
        )}
      </footer>
    </article>
  );
}

export { LessonViewer };
