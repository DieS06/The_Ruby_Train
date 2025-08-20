import React, {useEffect} from "react";
import { ToastContainer, toast } from "react-toastify";
import { ToastQueue } from "@/bundles/components/Utils/ToastQueue";
import { useToasts } from "@/stores/useToasts";

export default function GlobalToasts() {
    const position = useToasts((s) => s.position);
    const limit    = useToasts((s) => s.limit);

    useEffect(() => {
      const { onAdded, onRemoved } = useToasts.getState();

      const unsub = toast.onChange(({ status }) => {
          if (status === "added") onAdded();
          if (status === "removed") onRemoved();
      });
        return () => { unsub?.(); };
    });

  return (
    <>
        <ToastContainer
            autoClose={5000}
            limit={limit}
            position={position}
            closeOnClick={true}
            closeButton={true}
            pauseOnHover={true}
            draggable={true}  
            theme="colored"
            className="toast-container"
            progressClassName="toast-progress"
            hideProgressBar={false}
            newestOnTop={false}
        />
        <ToastQueue />
    </>
  );
}
