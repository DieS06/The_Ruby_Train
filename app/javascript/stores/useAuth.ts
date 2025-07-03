import { create } from "zustand";
import { persist } from "zustand/middleware";
import { type AuthState } from "../types/Auth/AuthState"

const useAuth = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,

      setUser: (user, token) => {
        set({ user, token });

        if (user.rememberMe) {
          localStorage.setItem("auth-persist-token", JSON.stringify({ token }));
          sessionStorage.removeItem("auth-temp-token");
        } else {
          sessionStorage.setItem("auth-temp-token", JSON.stringify({ token }));
          localStorage.removeItem("auth-persist-token");
        }
      },
        signOut: () => {
          sessionStorage.removeItem("auth-temp-token");
          localStorage.removeItem("auth-persist-token");
          set({ user: null, token: null });
      }
    }),
    {
      name: "auth-session-storage",
      storage: {
        getItem: (key) => {
          const localValue = localStorage.getItem("auth-persist-token");
          const sessionValue = sessionStorage.getItem("auth-temp-token");

          if(localValue) return JSON.parse(localValue);
          if(sessionValue) return JSON.parse(sessionValue);
          return null;
        },
        setItem: (key, value) => { },
        removeItem: (key) =>  { },
      },
      partialize: (state) => ({
        token: state.token,
        user: null,
        setUser: state.setUser,
        signOut: state.signOut,
      }),

      onRehydrateStorage: (state) => {
        return (state, error) => {
          if (error) console.error("Rehydration error:", error);
          if (state && state.token) {
            state.token = state.token;
            state.user = null;
          }
        };
      },
      version: 1,
    }
  )
);

export { useAuth };