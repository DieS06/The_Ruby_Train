import React, { useRef, useState} from "react";
import { FaEye, FaEyeSlash } from "react-icons/fa";
import { InputProps } from "../../../types/Input";
import { useFocusRing } from "@react-aria/focus";
import "../../../styles/components/Accesible_Assets/PasswordInput.scss";

function PasswordInput({ placeholder, name, value, onChange }: InputProps) {  
    const inputRef = useRef(null);
    const [showPassword, setShowPassword] = useState(false);
    const { isFocusVisible, focusProps } = useFocusRing();

  return (
    <div className="password-field">
        <input
        {...focusProps}
        ref={inputRef}
        type={showPassword ? "text" : "password"}
        name={name}
        value={value}
        aria-label={placeholder}
        onChange={onChange}
        placeholder={placeholder}
        className={isFocusVisible ? "focus-ring" : ""}
        />

        <button
        type="button"
        className={`icon-btn ${showPassword ? "show" : "hide"}`}
        aria-label={showPassword ? "Hide password" : "Show password"}
        onClick={() => setShowPassword(prev => !prev)}>
        {showPassword ? <FaEyeSlash/> : <FaEye/>}
        </button>
    </div>
  );
}

export { PasswordInput };