import React, { useEffect, useRef } from "react";
import "@/styles/actiontext/Trix_View.scss";

type Props = {
  lesson: {
    slug: string;
    title: string;
    description?: string | null;
    richBody?: string | null;
  };
  updatePath: string;
  csrfToken: string;
};

function TrixView({ lesson, updatePath, csrfToken }: Props) {
  const trixRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const editor = trixRef.current?.querySelector("trix-editor") as
      | (HTMLElement & { editor?: { loadHTML?: (html: string) => void } })
      | null;
      
    if (editor && lesson.richBody) {
      editor.editor?.loadHTML?.(lesson.richBody);
    }
  }, [lesson.richBody]);

  return (
    <form className="editor-form" action={updatePath} method="post" encType="multipart/form-data" data-turbo="false">
      <input type="hidden" name="_method" value="patch" />
      <input type="hidden" name="authenticity_token" value={csrfToken} />

      <div className="field lesson-title-container">
        <label htmlFor="lesson_title">Title</label>
        <input id="lesson_title" type="text" name="lesson[title]" defaultValue={lesson.title} />
      </div>

      <div className="field lesson-description-container">
        <label htmlFor="lesson_description">Description</label>
        <textarea id="lesson_description" name="lesson[description]" rows={3}
          defaultValue={lesson.description ?? ""} />
      </div>

      <div className="field lesson-body-container">
        <label>Lesson body</label>
        <input id="lesson_rich_body" type="hidden" name="lesson[rich_body]" />
        <div ref={trixRef}>
          <trix-editor input="lesson_rich_body"></trix-editor>
        </div>
      </div>

      <section className="attachments-container">
        <div className="field lesson-image-container">
          <label htmlFor="lesson_image">Image</label>

          {lesson.imageUrl && (
            <div className="preview-row">
              <img src={lesson.imageUrl} alt={lesson.slug} className="img-preview" />
              <label className="remove-chk">
                <input type="checkbox" name="remove_image" value="1" /> Remove image
              </label>
            </div>
          )}
          <input id="lesson_image" type="file" name="lesson[image]" accept="image/*" />
        </div>

        <div className="field lesson-video-container">
          <label htmlFor="lesson_video">Video</label>

          {lesson.videoUrl && (
            <div className="preview-row">
              <video src={lesson.videoUrl} className="video-preview" controls />
              <label className="remove-chk">
                <input type="checkbox" name="remove_video" value="1" /> Remove video
              </label>
            </div>
          )}
          <input id="lesson_video" type="file" name="lesson[video]" accept="video/*" />
        </div>
      </section>
    </form>
  );
}

export { TrixView };
