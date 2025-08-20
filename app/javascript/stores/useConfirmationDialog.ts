import { useEffect, useState } from "react";

export const useConfirmationDialog = () => {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const confirmed = params.get("notice");

    if (confirmed === "Your email address has been successfully confirmed.") {
      setOpen(true);
      params.delete("notice");
      const newUrl = `${window.location.pathname}`;
      window.history.replaceState({}, "", newUrl); // limpia la URL
    }
  }, []);

  return { open, setOpen };
};
