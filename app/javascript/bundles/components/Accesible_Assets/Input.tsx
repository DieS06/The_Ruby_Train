import React, { useRef } from "react";
import { InputProps } from "../../../types/Accesible_Assets/Input";
import { useFocusRing } from "@react-aria/focus";
import "../../../styles/components/Accesible_Assets/Input.scss";

function Input({ id, label, placeholder, ariaLabel, name, type="text", value, required, onChange }: InputProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const { isFocusVisible, focusProps } = useFocusRing();
  const inputId = id || name;
  const computedAriaLabel = label ? undefined : (ariaLabel || placeholder);

  return (
    <div className="field">
      {label && <label htmlFor={inputId} className="field-label">{label}</label>}
      <input
        {...focusProps}
        ref={inputRef}
        id={inputId}
        type={type}
        name={name}
        value={value}
        required={required}
        aria-label={computedAriaLabel}
        onChange={onChange}
        placeholder={placeholder}
        className={isFocusVisible ? "focus-ring" : ""}
      />
    </div>
  );
}

export { Input };