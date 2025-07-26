import React from "react"; 
import ReactOnRails from "react-on-rails";
import { start } from '@hotwired/turbo';
import "../styles/application.scss";
import "../i18n";

import Home from "@pages/Home";
import Profile from "@pages/Profile";

start();

ReactOnRails.setOptions({
  turbo: true,
  traceTurbolinks: process.env.TRACE_TURBOLINKS
});

ReactOnRails.register({
  Home,
  Profile,
});
