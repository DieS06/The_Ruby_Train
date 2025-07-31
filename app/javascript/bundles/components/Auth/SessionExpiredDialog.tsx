import React, {useEffect} from 'react'
import { DialogComponent } from '../Accesible_Assets/Dialog'
import { visit } from "@hotwired/turbo";
import "../../../styles/components/Auth/SessionExpiredDialog.scss";

interface Props {
  open: boolean
  onClose: () => void
}

function SessionExpiredDialog({ open, onClose }: Props) {
  const handleRedirect = () => {
    onClose()
    visit('/')
  }

  useEffect(() => {
    const root = document.body
    if (open) {
      root.classList.add('modal-on')
    } else {
      root.classList.remove('modal-on')
    }
  }, [open])

  return (
    <DialogComponent
      isOpen={open}
      onOpenChange={handleRedirect}
      ariaLabel="Session expired"
      trigger={null}
    >
      {() => (
        <div>
          <h2 className="dialog-title">Session expired</h2>
          <p className="dialog-description">
            Your session has expired. Please sign in again to continue.
          </p>
          <button className="dialog-button" onClick={handleRedirect}>
            Close
          </button>
        </div>
      )}
    </DialogComponent>
  )
}

export default SessionExpiredDialog;