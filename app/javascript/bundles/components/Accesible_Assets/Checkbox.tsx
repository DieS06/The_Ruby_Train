import React from "react";
import type { CheckboxProps } from "../../../types/Checkbox";
import "../../../styles/components/Accesible_Assets/Checkbox.scss";

function Checkbox({name, label, checked, onChange, required}: CheckboxProps) {
   return (
    <label className="checkbox-container">
      <input 
        className="checkbox" 
        type="checkbox"
        name={name}
        checked={checked}
        onChange={onChange}
        required={required}
        aria-label={label}
        />
      {label}
    </label>
  );
}
export { Checkbox };