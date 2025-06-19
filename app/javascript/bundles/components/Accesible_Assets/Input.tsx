import React, { useRef } from "react";
import { InputProps } from "../../../types/Input.type";
import { useFocusRing } from "@react-aria/focus";
import "../../../styles/components/Accesible_Assets/Input.scss";

function Input({ placeholder, name, type, value, onChange }: InputProps) {
  const inputRef = useRef(null);
  const { isFocusVisible, focusProps } = useFocusRing();

  return (
    <div className="field">
      <input
        {...focusProps}
        ref={inputRef}
        type={type}
        name={name}
        value={value}
        aria-label={placeholder}
        onChange={onChange}
        placeholder={placeholder}
        className={isFocusVisible ? "focus-ring" : ""}
      />
    </div>
  );
}

export { Input };