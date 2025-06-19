import React, { useRef } from "react";
import { useButton } from "@react-aria/button";
import "../../../styles/components/Accesible_Assets/SubmitButton.scss";

function SubmitButton({ children }: { children: React.ReactNode }) {
  const ref = useRef(null);
  const { buttonProps } = useButton({ type: "submit" }, ref);

  return (
    <button className="submit-btn" {...buttonProps} ref={ref}>
      {children}
    </button>
  );
}

export { SubmitButton };