import React from "react";
import { DialogComponent } from "../Accesible_Assets/Dialog"; 
import { useConfirmationDialog } from "../../../stores/useConfirmationDialog";

export default function ConfirmationDialog() {
  const { open, setOpen } = useConfirmationDialog();

  return (
    <DialogComponent
      ariaLabel="Account confirmation success"
      isOpen={open}
      onOpenChange={setOpen}
      trigger={null}
    >
      {(close) => (
        <div className="flow">
          <h2>✅ Account confirmed</h2>
          <p>Welcome aboard! Your email has been verified successfully.</p>
          <button onClick={close}>Continue</button>
        </div>
      )}
    </DialogComponent>
  );
}
