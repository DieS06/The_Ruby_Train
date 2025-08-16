import React from "react"; 
import ReactOnRails from "react-on-rails";
import { start } from '@hotwired/turbo';
import { ApolloProvider } from "@apollo/client";
import apolloClient from "../apollo/client";
import "../styles/application.scss";
import "../i18n";

import "trix";
import "trix/dist/trix.css";
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage";

import Home from "@pages/Home";
import Profile from "@pages/Profile";
import Course from "@pages/Course";
import Lesson from "@pages/Lesson";
import LessonEditor from "@pages/LessonEditor";
import Evaluation from "@pages/Evaluation"

import SessionExpiredWatcher from "../bundles/components/Auth/SessionExpiredWatcher";
import GlobalToasts from "../bundles/components/Utils/GlobalToasts";

ActiveStorage.start();
start();

ReactOnRails.setOptions({
  turbo: true,
  traceTurbolinks: process.env.TRACE_TURBOLINKS
});

function withApollo(Component) {
  return (props) => (
    <ApolloProvider client={apolloClient}>
      <Component {...props} />
    </ApolloProvider>
  );
}

ReactOnRails.register({
  Home,
  SessionExpiredWatcher,
  GlobalToasts,
  ProfileApp: withApollo(Profile),
  CourseApp: withApollo(Course),
  LessonApp: withApollo(Lesson),
  LessonEditorApp: withApollo(LessonEditor),
  EvaluationApp: withApollo(Evaluation),
});
