import React, { useState } from "react";
import DOMPurify from "dompurify";
import { useQuery } from "@apollo/client";
import type { ContentUnit } from "@/types/Content/ContentUnit";
import { useLessonNavigator } from "@/stores/useLessonNavigator";
import LessonNavCarousel from "./LessonNavCarousel";
import EvaluationDialog from "../../components/Evaluation/EvalautionDialog";
import { FIND_LESSON_NAV } from "../../../apollo/queries/content_unit/find_lessons_nav";
import "../../../styles/components/Content_Unit/LessonViewer.scss";

interface Props {
  lesson: ContentUnit & {
    position?: number;          
    videoUrl?: string | null;
    imageUrl?: string | null;
    richBody?: string | null;
    nextSlug?: string | null;
  };
}

function LessonViewer({ lesson }: Props) {
  const { items, goToLesson, loading: navLoading } = useLessonNavigator(lesson.slug);
  const [showQuiz, setShowQuiz] = useState(false);


  const { data: navData } = useQuery(FIND_LESSON_NAV, {
    variables: { slug: lesson.slug },
    fetchPolicy: "cache-first",
  });

  const quizId: number | undefined = navData?.findLessonNav?.quizId;

  const isFourthLesson = lesson?.position === 4;

  if (!lesson) return null;

  const clean = DOMPurify.sanitize(lesson.richBody ?? "", {
    ADD_TAGS: ["action-text-attachment"],
    ADD_ATTR: ["content-type", "url", "filename", "filesize", "caption"],
  });

  return (
    <article className="lesson-viewer" key={lesson.id}>
      <div className="lesson-video-container">
        {lesson.videoUrl ? (
          <video className="lesson-video" controls src={lesson.videoUrl} />
        ) : (
          <div className="lesson-video-placeholder">
            <video controls className="lesson-video" src={lesson.videoUrl ?? undefined} />
          </div>
        )}
      </div>

      <LessonNavCarousel loading={navLoading} items={items} onNavigate={goToLesson} />

      <header className="lesson-header">
        <h1 className="lesson-title">{lesson.title}</h1>
        {lesson.description && <p className="lesson-description">{lesson.description}</p>}
      </header>

  
      {isFourthLesson && quizId && (
        <div className="lesson-actions mb-3">
          <button
            className="btn btn-primary"
            onClick={() => setShowQuiz(true)}
            title="Take Quiz for this Segment"
          >
            Take Quiz
          </button>
        </div>
      )}

      <main className={`lesson-body ${lesson.imageUrl ? "" : "no-image"}`}>
        <section className="lesson-content" dangerouslySetInnerHTML={{ __html: clean }} />
        {lesson.imageUrl && <img src={lesson.imageUrl} alt={lesson.title} className="lesson-image" />}
      </main>

      {quizId && (
        <EvaluationDialog
          open={showQuiz}
          evaluationId={quizId}
          onClose={() => setShowQuiz(false)}
          onPassed={(_score, _passed) => {
            // toast or UI updates
          }}
        />
      )}
    </article>
  );
}

export { LessonViewer };
