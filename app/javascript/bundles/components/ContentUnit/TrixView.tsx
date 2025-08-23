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
    <form
      className="editor-form"
      action={updatePath}
      method="post"
      encType="multipart/form-data"
      data-turbo="false"
    >
      <input type="hidden" name="_method" value="patch" />
      <input type="hidden" name="authenticity_token" value={csrfToken} />

      <section className="editor-header">
        <div className="field-editor">
          <label htmlFor="lesson_title">Title</label>
          <input
            id="lesson_title"
            type="text"
            name="lesson[title]"
            defaultValue={lesson.title}
            placeholder="Lesson title"
          />
        </div>

        <div className="field-editor">
          <label htmlFor="lesson_description">Description</label>
          <textarea
            id="lesson_description"
            name="lesson[description]"
            rows={3}
            placeholder="Short summary shown in lists"
            defaultValue={lesson.description ?? ""}
          />
        </div>
      </section>

      <section className="editor-body">
        <div className="field-editor">
          <label htmlFor="lesson_rich_body">Lesson body</label>
          <input id="lesson_rich_body" type="hidden" name="lesson[rich_body]" />
          <div className="trix-wrap" ref={trixRef}>
            <trix-editor input="lesson_rich_body"></trix-editor>
          </div>
          <p className="hint">Use headings, code blocks, and lists for readability.</p>
        </div>
      </section>

      <section className="attachments-grid">
        <div className="field-editor">
          <label htmlFor="lesson_image">Image</label>
          <label className="file-field">
            <input
              id="lesson_image"
              type="file"
              name="lesson[image]"
              accept="image/*"
              onChange={(e) => {
                const fileName = e.target.files?.[0]?.name || "No file selected";
                const span = e.target.parentElement?.querySelector(".file-name");
                if (span) span.textContent = fileName;
              }}
            />
            <span className="file-btn">Choose image</span>
            <span className="file-name">No file selected</span>
          </label>
          <p className="hint">PNG/JPG up to ~5MB. Shown beside the lesson body.</p>
        </div>

        <div className="field-editor">
          <label htmlFor="lesson_video">Video</label>
          <label className="file-field">
            <input
              id="lesson_video"
              type="file"
              name="lesson[video]"
              accept="video/*"
              onChange={(e) => {
                const fileName = e.target.files?.[0]?.name || "No file selected";
                const span = e.target.parentElement?.querySelector(".file-name");
                if (span) span.textContent = fileName;
              }}
            />
            <span className="file-btn">Choose video</span>
            <span className="file-name">No file selected</span>
          </label>
          <p className="hint">MP4/WebM. Optional; appears above the content.</p>
        </div>
      </section>

      <div className="actions">
        <input type="submit" value="Save" className="submit-btn" />
      </div>
    </form>
  );
}

export { TrixView };
