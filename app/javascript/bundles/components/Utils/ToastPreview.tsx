import React from "react";
import { toastAlert } from "./toasts";
import HelpIcon from "./AnimIcons/HelpIcon";

export default function ToastPreview() {
  const showAllToasts = () => {
    toastAlert.success("alerts.login_success");
    toastAlert.error("alerts.login_failed");
    toastAlert.info("alerts.info_message");
    toastAlert.warn("alerts.warn_message");
    toastAlert.def("alerts.default_message");
    toastAlert.load("alerts.loading_message");
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
