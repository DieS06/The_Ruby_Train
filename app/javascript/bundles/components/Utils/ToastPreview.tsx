import React from "react";
import { alert } from "./toasts";
import HelpIcon from "./AnimIcons/HelpIcon";

export default function ToastPreview() {
  const showAllToasts = () => {
    alert.success("alerts.login_success");
    alert.error("alerts.login_failed");
    alert.info("alerts.info_message");
    alert.warn("alerts.warn_message");
    alert.def("alerts.default_message");
    alert.load("alerts.loading_message");
  };

  return (
    <button 
      onClick={showAllToasts}
      className="toast-preview-btn"
      style={{ backgroundColor: "transparent", border: "none" }}
      >
      <HelpIcon
      size={45}
      loop={false}
     />
    </button>
  );
}
