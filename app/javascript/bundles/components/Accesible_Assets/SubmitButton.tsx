import React, { useRef } from "react";
import { useButton } from "@react-aria/button";
import { SubmitButtonProps } from "../../../types/Accesible_Assets/SubmitButton";
import "../../../styles/components/Accesible_Assets/SubmitButton.scss";

function SubmitButton({ children, disabled = false, onPress, ...props }: SubmitButtonProps) {
  const ref = useRef(null);
  const { buttonProps } = useButton({ type: "submit", isDisabled: disabled, ...props }, ref);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (disabled && onPress) {
      e.preventDefault(); 
      onPress();
    } else if (props.onClick) {
      props.onClick(e);
    }
  };

  return (
    <button 
      className="submit-btn" 
      {...buttonProps} 
      ref={ref}
    >
      {children}
    </button>
  );
}

export { SubmitButton };