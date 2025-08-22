import React from "react";
import { useQuery } from "@apollo/client";
import { FIND_COURSE_HIERARCHY } from "@/apollo/queries/content_unit/find_course_hierarchy";
import courseLogo from "../../../assets/imgs/TRT_Logo_v1.png";
import Spinner from "../Loading/Spinner";
import "../../../styles/components/Home/CourseOutline.scss";

type Node = {
    id: string;
    title: string;
    kind?: "course" | "section" | "segment" | "lesson" | string;
    description?: string | null;
    children?: Node[] | null;
};

function numLabel(parts: number[], sep: "." , space = true) {
  const core = parts.join(sep);
  const tail = sep === "." ? "." : "";
  const gap  = space ? " " : "";
  return `${core}${tail}${gap}`;
}

const LessonsList: React.FC<{ 
  lessons: Node[] ;
  secIndex: number;
  segIndex: number;
  sep?: ".";
  space?: boolean;
}> = ({ lessons, secIndex, segIndex, sep = ".", space = true }) => (

  <ul className="lessons">
    {lessons.map((l, i) => {
       const label = numLabel([secIndex + 1, segIndex + 1, i + 1], sep, space);
      return (
        <li key={l.id} className="lesson">
          <h5 className="lesson-title">
            <span className="num">{label}</span>
            {l.title}
          </h5>
          {l.description && <p className="lesson-desc">{l.description}</p>}
        </li>
      );
    })}
  </ul>
);

const SegmentCard: React.FC<{ 
  segment: Node;
  secIndex: number;
  index: number;
  sep?: ".";
  space?: boolean;
}> = ({ segment, secIndex, index, sep = ".", space = true }) => {
  const lessons = segment.children ?? [];
  const label = numLabel([secIndex + 1, index + 1], sep, space);

  return (
    <article className="segment-card">
      <h4 className="segment-title">
        <span className="num">{label}</span>
        {segment.title}</h4>
      {segment.description && (
        <p className="segment-desc">{segment.description}</p>
      )}
      {lessons.length > 0 && (
      <LessonsList 
      lessons={lessons}
      secIndex={secIndex}
      segIndex={index}
      sep={sep}
      space={space}
      />
      )}
    </article>
  );
};

const SectionBlock: React.FC<{ 
  section: Node;
  index: number;
  sep?: ".";
  space?: boolean;
 }> = ({ section, index, sep = ".", space = true }) => {
  const segments = section.children ?? [];
  const label = numLabel([index + 1], sep, space);

  return (
    <section className="section-block">
      <h3 className="section-title">
        <span className="num">{label}</span>
        {section.title}</h3>
 
      <div className="segments-grid">
        {segments.map((seg, i) => (
          <SegmentCard 
          key={seg.id} 
          segment={seg} 
          secIndex={index} 
          index={i}
          sep={sep}
          space={space}
          />
        ))}
      </div>
    </section>
  );
};

const CourseOutline: React.FC = () => {
  const { data, loading, error } = useQuery(FIND_COURSE_HIERARCHY);
  if (loading) return <Spinner />;
  if (error) return <p>Error: {error.message}</p>;

  const course: Node | undefined = data?.findContentUnitWithHierarchy;
  if (!course) return <p>No course found.</p>;

  const sections = course.children ?? [];

  const sep: "." = ".";
  const space = true;

  return (
    <div className="course-outline">
      <section className="course-header">
        <img src={courseLogo} alt="The Ruby Train Logo" className="course-logo" />
        {/* {course.description && (
          <p className="course-desc">{course.description}</p>
        )} */}
      </section>

      <div className="course-body">
        {sections.map((sec, i) => (
          <SectionBlock 
            key={sec.id} 
            section={sec} 
            index={i} 
            sep={sep} 
            space={space} 
          />
        ))}
      </div>
    </div>
  );
};

export default CourseOutline;