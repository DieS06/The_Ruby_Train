import React from "react";
import { visit } from "@hotwired/turbo";
import { TriggerButton } from "../Accesible_Assets/TriggerButton";
import { useCourseNavigator } from "@/stores/useCourseNavigator";
import courseLogo from "../../../assets/imgs/TRT_Logo_v1.png";
import Spinner from "../Loading/Spinner";
import "@/styles/components/Content_Unit/CourseNavigator.scss";

function CourseNavigator() {
    const { course, loading } = useCourseNavigator();
    if (loading || !course) return <Spinner />;

    return (
        <div className="course-navigator">
            <div className="course-header">
                <img src={courseLogo} alt="The Ruby Train Logo" className="course-logo" />
            </div>

            {course.children?.map((module) => (
                <div key={module.id} className="module-block">
                    <h3>Module: {module.title}</h3>
                    {module.children?.map((segment) => (
                        <div key={segment.id} className="segment-block">
                        <h4>{segment.title}</h4>
                        {segment.children?.map((lesson) => (
                            <TriggerButton key={lesson.id} onClick={() => visit(`/content_units/${lesson.slug}`)}>
                            {lesson.title}
                            </TriggerButton>
                        ))}
                        </div>
                    ))}
                    </div>
                ))}
                </div>
    );
}

export { CourseNavigator };