import React, { useRef } from "react";
import { useSelect, HiddenSelect } from "@react-aria/select";
import { useSelectState } from "@react-stately/select";
import { ListBox, Popover } from "react-aria-components";
// import "../../../styles/components/Accesible_Assets/SelectField.scss";

interface Option { value: string; label: string; }

interface Props {
  label: string;
  name: string;
  options: Option[];
  selected: string;
  onChange: (val: string) => void;
}

function SelectField({ label, name, options, selected, onChange }: Props) {
  const ref = useRef<HTMLButtonElement | null>(null);
  const state = useSelectState({
    selectedKey: selected,
    onSelectionChange: (key) => onChange(String(key)),
    items: options,
  });
  const { labelProps, triggerProps, valueProps, menuProps } = useSelect({}, state, ref);
  return (
    <div className="select-field">
      <span {...labelProps}>{label}</span>
      <button {...triggerProps} ref={ref} className="select-btn">
        <span {...valueProps}>{state.selectedItem?.textValue}</span>
      </button>
      <HiddenSelect state={state} name={name} triggerRef={ref} />
      {state.isOpen && (
        <Popover>
          <ListBox {...menuProps} className="select-menu" />
        </Popover>
      )}
    </div>
  );
}

export { SelectField };
