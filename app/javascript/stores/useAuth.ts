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
          localStorage.removeItem("rememberMe");
        }
      },

    signOut: () => {
      localStorage.removeItem("rememberMe");
      set({ user: null });
      }, clear:() => set({ user: null })
    }),
    {
      name: "auth-storage",
      partialize: (s) => ({
        user: s.user,
        // setUser: s.setUser,
        // signOut: s.signOut,
      }),
    }
  )
);

export { useAuth };