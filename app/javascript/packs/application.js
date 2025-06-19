import React from "react"; 
import { createRoot } from "react-dom/client";
import "../styles/application.scss";
import Home from "../bundles/pages/Home";

const container = document.getElementById("root");

if (container) {
  const root = createRoot(container);
  root.render(<Home />);
}

