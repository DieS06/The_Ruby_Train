import { create } from "zustand";
import { persist } from "zustand/middleware";
import { type AuthState } from "../types/Auth/AuthState"

const useAuth = create<AuthState>()(
  persist(
    (set) => ({
      user: null,

      setUser: (user) => {
        set({ user });

        if (user.rememberMe) {
          localStorage.setItem("rememberMe", user.email);
        } else {
          localStorage.removeItem("");
        }
      },

    signOut: () => {
      set({ user: null });
      }
    }),
    {
      name: "auth-storage",
      partialize: (state) => ({
        user: state.user,
        setUser: state.setUser,
        signOut: state.signOut,
      }),
    }
  )
);

export { useAuth };