import { type Credentials } from "./UserCredentials";

type AuthState = {
  user: Credentials | null;
  token: string | null;
  setUser: (user: Credentials, token: string) => void;
  signOut: () => void;
};

export type { AuthState };