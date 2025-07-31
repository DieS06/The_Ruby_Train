import React from "react";
import { useAuth } from "@/stores/useAuth";
import AuthGate from "../components/Wrappers/AuthGate";
import { useQuery } from "@apollo/client";
import { FIND_LESSON_BY_SLUG } from "../../apollo/queries/content_unit/find_lesson_by_slug";
import { LessonViewer } from "@/bundles/components/ContentUnit/LessonVIewer";
import Spinner from "../components/Loading/Spinner";
import DashboardLayout from "../layouts/Dashboard";
import "../../styles/components/Content_Unit/LessonViewer.scss";

export default function Lesson() {
    const { user } = useAuth();
    const slug = window.location.pathname.split("/").pop();
    const { data, loading, error } = useQuery(FIND_LESSON_BY_SLUG, {
        variables: { slug },
    });
    const isLoading = loading || !user;
    const lesson = data?.findLessonWithExtras;

    if (isLoading) return <Spinner />;
    if (error) return <p>Error: {error.message}</p>;
    if (!lesson) return <p>No lesson found.</p>;

    return (
        <AuthGate>
            <DashboardLayout activeTab="course" userRole={user.roleNames}>
                <main className="lesson-page">
                    <LessonViewer lesson={lesson} />
                </main>
            </DashboardLayout>
        </AuthGate>
    );
}
