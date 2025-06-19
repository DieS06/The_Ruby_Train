import React, { useRef } from "react";
import type { CheckboxProps } from "../../../types/Checkbox.type";
import { useCheckbox } from "@react-aria/checkbox";
import { useToggleState } from "@react-stately/toggle";
import "../../../styles/components/Accesible_Assets/Checkbox.scss";

function Checkbox({name, label, checked, onChange}: CheckboxProps) {
    const ref = useRef(null);
    const state = useToggleState({ 
      isSelected: checked, 
      onChange: (isSelected) => {
        onChange({
          target: { checked: isSelected } as any,
        } as React.ChangeEvent<HTMLInputElement>);
      } });
    const { inputProps } = useCheckbox(
      {
        name,
        isSelected: checked,
        "aria-label": label,
      },
      state, ref);

  return (
    <label className="checkbox-container">
      <input className="checkbox" {...inputProps} ref={ref} />
      {label}
    </label>
  );
}
export { Checkbox };