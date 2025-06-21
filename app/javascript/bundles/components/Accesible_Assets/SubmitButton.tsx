import React, { useRef } from "react";
import { useButton } from "@react-aria/button";
import { SubmitButtonProps } from "../../../types/SubmitButton";
import "../../../styles/components/Accesible_Assets/SubmitButton.scss";

function SubmitButton({ children, disabled = false, ...props }: SubmitButtonProps) {
  const ref = useRef(null);
  const { buttonProps } = useButton({ type: "submit", ...props }, ref);

  return (
    <button 
      className="submit-btn" 
      {...buttonProps} 
      ref={ref}
      disabled={disabled} 
    >
      {children}
    </button>
  );
}

export { SubmitButton };