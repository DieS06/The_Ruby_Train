import React from "react"; 
import ReactOnRails from "react-on-rails";
import { start } from '@hotwired/turbo';
import { ApolloProvider } from "@apollo/client";
import apolloClient from "../apollo/client";
import "../styles/application.scss";
import "../i18n";

import Home from "@pages/Home";
import Profile from "@pages/Profile";
import Course from "@pages/Course";
import Lesson from "@pages/Lesson";
import SessionExpiredWatcher from "../bundles/components/Auth/SessionExpiredWatcher";

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
  ProfileApp: withApollo(Profile),
  CourseApp: withApollo(Course),
  LessonApp: withApollo(Lesson),
});
