import React, { useRef } from "react";
import { useButton } from "@react-aria/button";
import type { TriggerProps } from "../../../types/Accesible_Assets/Trigger";
import "../../../styles/components/Accesible_Assets/TriggerButton.scss";

function TriggerButton({ children, onClick }: TriggerProps) {
  const ref = useRef(null);
  const { buttonProps } = useButton({ onPress: onClick, type: "button" }, ref);

  return (
    <button className="trigger-btn" {...buttonProps} ref={ref}>
      {children}
    </button>
  );
}

export { TriggerButton };