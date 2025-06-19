import React, { useRef } from "react";
import { useButton } from "@react-aria/button";
import "../../../styles/components/Accesible_Assets/TriggerButton.scss";

function TriggerButton({ children }: { children: React.ReactNode }) {
  const ref = useRef(null);
  const { buttonProps } = useButton({ type: "button" }, ref);

  return (
    <button className="trigger-btn" {...buttonProps} ref={ref}>
      {children}
    </button>
  );
}

export { TriggerButton };