import { useEffect, useState } from "react";

export function useCountdown(deadline?: string | null, onExpire?: () => void) {
  const [secs, setSecs] = useState(() => {
    if (!deadline) return 0;
    return Math.max(0, Math.floor((new Date(deadline).getTime() - Date.now()) / 1000));
  });

  useEffect(() => {
    if (!deadline) return;
    const id = setInterval(() => {
      setSecs((s) => {
        const next = Math.max(0, s - 1);
        if (next === 0) {
          clearInterval(id);
          onExpire?.();
        }
        return next;
      });
    }, 1000);
    return () => clearInterval(id);
  }, [deadline, onExpire]);

  const mm = String(Math.floor(secs / 60)).padStart(2, "0");
  const ss = String(secs % 60).padStart(2, "0");
  return { secs, label: `${mm}:${ss}` };
}
