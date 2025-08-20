import React from "react";
import DOMPurify from 'dompurify';
import type { ContentUnit } from "@/types/Content/ContentUnit";
import { useLessonNavigator } from "@/stores/useLessonNavigator";
import LessonNavCarousel from "./LessonNavCarousel"
import "../../../styles/components/Content_Unit/LessonViewer.scss";

interface Props {
  lesson: ContentUnit & {
    videoUrl?: string | null;
    imageUrl?: string | null;
    richBodyHtml?: string | null;
    nextSlug?: string | null;
  };
}

function LessonViewer({ lesson }: Props) {
  const {
    items,
    goToLesson,
    loading: navLoading,
  } = useLessonNavigator(lesson.slug);

  if (!lesson) return null;

  return (
    <article className="lesson-viewer" key={lesson.id}>
      <div className="lesson-video-container">
        {lesson.videoUrl ? (
          <video
            className="lesson-video"
            controls
            src={lesson.videoUrl}
          />
        ) : (
          <div className="lesson-video-placeholder">
            <video controls className="lesson-video" src={lesson.videoUrl ?? undefined} />
          </div>
        )}
      </div>

      <LessonNavCarousel 
        loading={navLoading}
        items={items}
        onNavigate={goToLesson}
      />

      <header className="lesson-header">
        <h1 className="lesson-title">{lesson.title}</h1>
        {lesson.description && (
          <p className="lesson-description">{lesson.description}</p>
        )}
      </header>
      
      <main className="lesson-body"> 
      <section
        className="lesson-content"
        dangerouslySetInnerHTML={{
          __html: DOMPurify.sanitize(lesson.richBodyHtml ?? ""),
        }}
      />

      {lesson.imageUrl && (
        <img
          src={lesson.imageUrl}
          alt={lesson.title}
          className="lesson-image"
        />
      )}     
      </main>    
    </article>
  );
}

export { LessonViewer };
