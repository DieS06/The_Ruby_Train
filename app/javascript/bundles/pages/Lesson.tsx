import React from "react";
import { useAuth } from "@/stores/useAuth";
import AuthGate from "../components/Wrappers/AuthGate";
import { useQuery } from "@apollo/client";
import { FIND_LESSON_BY_SLUG } from "../../apollo/queries/content_unit/find_lesson_by_slug";
import { LessonViewer } from "@/bundles/components/ContentUnit/LessonViewer";
import Spinner from "../components/Loading/Spinner";
import DashboardLayout from "../layouts/Dashboard";
import "../../styles/pages/Lesson.scss";
import { Pencil } from "lucide-react";

type PageProps = {
  lessonSlug: string;
  canEdit?: boolean;
  editUrl?: string;
};

export default function Lesson(props: PageProps) {
    const { canEdit, editUrl } = props;
    const { user } = useAuth();
    const slug = window.location.pathname.split("/").pop();
    const { data, loading, error } = useQuery(FIND_LESSON_BY_SLUG, {
        variables: { slug },
        fetchPolicy: 'network-only',
        nextFetchPolicy: 'cache-first',
    });
    const isLoading = loading || !user;
    const lesson = data?.findLessonWithExtras;

    if (isLoading) return <Spinner />;
    if (error) return <p>Error: {error.message}</p>;
    if (!lesson) return <p>No lesson found.</p>;

    return (
        <AuthGate>
            <DashboardLayout activeTab="course" userRole={user.roleNames}>
                {canEdit && editUrl && (
                    <div className="lesson-admin-actions">
                        <a className="btn btn-secondary" href={editUrl}>
                            <Pencil />
                        </a>
                    </div>
                )}
                <main className="lesson-page" key={lesson.id}>
                    <LessonViewer lesson={lesson} />
                </main>
            </DashboardLayout>
        </AuthGate>
    );
}
