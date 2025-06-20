import { create } from "zustand";
import { persist } from "zustand/middleware";
import { type AuthState } from "../types/AuthState.type";

const useAuth = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      setUser: (user, token) => set({ user, token }),
      signOut: () => set({ user: null, token: null }),
    }),
    {
      name: "auth-storage",
    }
  )
);

export { useAuth };