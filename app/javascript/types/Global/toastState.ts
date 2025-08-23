import type { ToastPosition } from "react-toastify";
import { number } from "zod";

type ToastState = {
  position: ToastPosition;
  limit: number;
  showing: number;
  waiting: number;

  setPosition: (pos: ToastPosition) => void;
  setLimit: (n: number) => void;

  fired: () => void;
  onAdded: () => void;
  onRemoved: () => void;
};

export type { ToastState };