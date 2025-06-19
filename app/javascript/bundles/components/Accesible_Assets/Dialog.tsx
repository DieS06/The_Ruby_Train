import React from 'react';
import { DialogTrigger, Modal, Dialog } from 'react-aria-components';
import '../../../styles/components/Accesible_Assets/Dialog.scss';


interface DialogProps {
  trigger: React.ReactNode;
  children: (close: () => void) => React.ReactNode;
  ariaLabel?: string;
  isDismissable?: boolean;
}

function DialogComponent({ trigger, children, ariaLabel,
     isDismissable = true }: DialogProps) {
  return (
    <DialogTrigger>
      {trigger}
      <Modal isDismissable={isDismissable} className="dialog-overlay">
        <Dialog aria-label={ariaLabel} className="dialog-content">
          {({ close }) => children(close)}
        </Dialog>
      </Modal>
    </DialogTrigger>
  );
}

export { DialogComponent }