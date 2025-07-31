import React from "react";
import { useAuth } from "@/stores/useAuth"
import AuthGate from "../components/Wrappers/AuthGate";
import DashboardLayout from "../layouts/Dashboard";
import { useQuery } from "@apollo/client";
import { FIND_COURSE_HIERARCHY } from "../../apollo/queries/content_unit/find_course_hierarchy";
import { CourseNavigator } from "../components/ContentUnit/CourseNavigator";
import "@/styles/pages/Course.scss";
import Spinner from "../components/Loading/Spinner";


const Course: React.FC = () => {
    const { data, loading, error } = useQuery(FIND_COURSE_HIERARCHY);
    const { user } = useAuth();
    const isLoading = loading || !user;
    const course = data?.findContentUnitWithHierarchy;

    if (isLoading) return <Spinner />;
    if (error) return <p>Error: {error.message}</p>;   
    if (!course) return <p>No course found.</p>;

    return (
        <AuthGate>
            <DashboardLayout
                activeTab="course"
                userRole={user.roleNames}
            >
                <main className="course-page">
                    <CourseNavigator course={course} />
                </main>
            </DashboardLayout>
        </AuthGate>
    )
}

export default Course;