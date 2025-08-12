import React, { useRef, useState } from "react";
import { useFocusRing } from "@react-aria/focus";
import type { TextAreaProps } from "../../../types/Accesible_Assets/TextArea";
import "../../../styles/components/Accesible_Assets/TextArea.scss";

function TextArea({ id, label, placeholder, ariaLabel, name, value, required, 
  rows=5, onChange, maxLength, showCount=false }: TextAreaProps) {

    const ref = useRef<HTMLTextAreaElement>(null);
    const { isFocusVisible, focusProps } = useFocusRing();
    const areaId = id || name;
    const computedAriaLabel = label ? undefined : (ariaLabel || placeholder);
    const [isComposing, setIsComposing] = useState(false);
    const count = value.length ?? 0;
    const counterId = `${name}-counter`;
    
    const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      if (!maxLength) return onChange(e);
      const next = e.target.value;

      if (!isComposing && next.length > maxLength) {
        e.target.value = next.slice(0, maxLength);
      }
      onChange(e);
    };

    const handlePaste = (e: React.ClipboardEvent<HTMLTextAreaElement>) => {
    if (!maxLength) return;
    const paste = e.clipboardData.getData("text");
    const sel = e.currentTarget.selectionEnd - e.currentTarget.selectionStart;
    const current = value.length - sel;
    const room = maxLength - current;
    if (room <= 0) {
      e.preventDefault();
      return;
    }
    if (paste.length > room) {
      e.preventDefault();
      const toInsert = paste.slice(0, room);
      const el = e.currentTarget;
      const start = el.selectionStart;
      const end = el.selectionEnd;
      const next = value.slice(0, start) + toInsert + value.slice(end);
      const synthetic = {
        ...e,
        target: { ...el, value: next },
        currentTarget: { ...el, value: next },
      } as unknown as React.ChangeEvent<HTMLTextAreaElement>;
      onChange(synthetic);
    }
  };

  return (
    <div className="field">
      <div className="field-header">
        {label && <label htmlFor={areaId} className="field-label">{label}</label>}
      
        {showCount && (
          <div id={counterId} className="char-counter" aria-live="polite">
            {maxLength ? `${count}/${maxLength}` : count}
          </div>
        )}
      </div>

      <textarea
        {...focusProps}
        ref={ref}
        id={areaId}
        name={name}
        value={value}
        required={required}
        rows={rows}
        placeholder={placeholder}
        aria-label={computedAriaLabel}
        aria-describedby={showCount ? counterId : undefined}
        className={isFocusVisible ? "focus-ring" : ""}
        onChange={handleChange}
        onPaste={handlePaste}
        onCompositionStart={() => setIsComposing(true)}
        onCompositionEnd={(e) => {
          setIsComposing(false);
          if (maxLength && e.currentTarget.value.length > maxLength) {
            const trimmed = e.currentTarget.value.slice(0, maxLength);
            const synthetic = {
              ...e,
              target: { ...e.currentTarget, value: trimmed },
              currentTarget: { ...e.currentTarget, value: trimmed },
            } as unknown as React.ChangeEvent<HTMLTextAreaElement>;
            onChange(synthetic);
          }
        }}
      >
      </textarea>
    </div>
  );
}
export { TextArea };
