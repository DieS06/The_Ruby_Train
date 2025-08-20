import React from "react";
import { useToasts } from "@/stores/useToasts";
import "@/styles/toasts/toastQueue.scss";

function ToastQueue() {
    const waiting = useToasts((s) => s.waiting);

    if (waiting <= 0) return null;

    return (
        <div className="toast-queue">Queue: {waiting}</div>
    );
}

export { ToastQueue };