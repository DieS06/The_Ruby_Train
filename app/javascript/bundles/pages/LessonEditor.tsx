import React from "react";
import "trix";
import "trix/dist/trix.css";
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage";
import DashboardLayout from "@/bundles/layouts/Dashboard";
import { TrixView } from "../components/ContentUnit/TrixView";
import { ApolloProvider } from "@apollo/client";
import apolloClient from "@/apollo/client";
import "@/styles/actiontext/Lesson_Editor.scss";
import BackButton from "../components/Accesible_Assets/BackButton";

ActiveStorage.start();

type Props = {
  lesson: {
    id: string;
    slug: string;
    title: string;
    description?: string | null;
    richBodyHtml?: string | null;
    imageUrl?: string | null;
    videoUrl?: string | null;
  };
  updatePath: string;
  csrfToken: string;
  userRole: string[];
};

function LessonEditor(props: Props) {
  const { userRole, lesson, updatePath, csrfToken } = props;

  return (
    <ApolloProvider client={apolloClient}>
      <DashboardLayout activeTab="course" userRole={userRole}>
        <main className="page admin-editor">
          <TrixView lesson={lesson} updatePath={updatePath} csrfToken={csrfToken} />

          <div className="lesson-editor-actions">
            <BackButton />
          </div>
        </main>
      </DashboardLayout>
    </ApolloProvider>
  );
}

export default LessonEditor;