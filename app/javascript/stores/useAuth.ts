import { create } from "zustand";
import { persist } from "zustand/middleware";

type User = {
  email: string;
  name?: string;
};

type AuthState = {
  user: User | null;
  token: string | null;
  setUser: (user: User, token: string) => void;
  signOut: () => void;
};

export const useAuth = create<AuthState>()(
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
