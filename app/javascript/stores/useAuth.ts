import { create } from "zustand";
import { persist } from "zustand/middleware";
import { type AuthState } from "../types/Auth/AuthState";
import { User } from "lucide-react";

const useAuth = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,

      setUser: (user, token) => {
        set({ user, token });

        if (!user.rememberMe) {
          sessionStorage.setItem("auth-temp", JSON.stringify({user, token}));
          localStorage.removeItem("auth-storage");
        }
      },
        signOut: () => {
          sessionStorage.removeItem("auth-temp");
          localStorage.removeItem("auth-storage");
          set({ user: null, token: null })
      }
    }),
    {
      name: "auth-storage",
      storage: {
        getItem: (key) => {
          const value = localStorage.getItem(key);
          return value ? JSON.parse(value) : null;
        },
        setItem: (key, value) => localStorage.setItem(key, JSON.stringify(value)),
        removeItem: (key) => localStorage.removeItem(key),
      },
    }
  )
);

export { useAuth };