import { create } from "zustand";
import type { ToastPosition } from "react-toastify";
import type { ToastState } from "@/types/toastState";

export const useToasts = create<ToastState>((set) => ({
  position: "top-right",
  limit: 3,
  showing: 0,
  waiting: 0,

  setPosition: (position) => set({ position }),
  setLimit: (limit) => set({ limit }),

  fired: () =>
    set((s) => ({ waiting: s.showing >= s.limit ? s.waiting + 1 : s.waiting })),

  onAdded: () =>
    set((s) => ({
      showing: s.showing + 1,
      waiting: s.waiting > 0 ? s.waiting - 1 : 0,
    })),

  onRemoved: () =>
    set((s) => ({ showing: Math.max(0, s.showing - 1) })),
}));
