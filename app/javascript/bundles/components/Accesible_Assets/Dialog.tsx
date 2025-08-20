import React from 'react';
import { Modal, Dialog } from 'react-aria-components';
import '../../../styles/components/Accesible_Assets/Dialog.scss';

interface DialogProps {
  trigger: React.ReactNode;
  children: (close: () => void) => React.ReactNode;
  ariaLabel?: string;
  isDismissable?: boolean;
  isOpen?: boolean;
  onOpenChange?: (isOpen: boolean) => void;
}

function DialogComponent({ trigger, children, ariaLabel,
     isDismissable = true, isOpen, onOpenChange }: DialogProps) {
      
  return (
    <>
      {trigger}
      <Modal  
      isDismissable={isDismissable} 
      isOpen={isOpen}
      onOpenChange={onOpenChange}
      className="dialog-overlay">
        <Dialog aria-label={ariaLabel} className="dialog-content">
          {({ close }) => children(close)}
        </Dialog>
      </Modal>
    </>
  );
}

export { DialogComponent }