import { UserInformation } from "../Profile/UserInformation";

export interface UserCredentials {
  email: string;
  password?: string;
  rememberMe?: boolean;
  state?: string;
};

export type AuthStoreUser = Pick<UserInformation, "email"> & { 
    rememberMe?: boolean;
    roleNames: string[];
};

export interface UserAuthState {
    user: AuthStoreUser | null;
    setUser: (user: AuthStoreUser) => void;
    signOut: () => void;
};

export interface RegisterData {
    first_name: string;
    last_name: string;
    country: string;
    phone_number: string;
    email: string;
    password: string;
    password_confirmation: string;
    accept_terms?: boolean;
};

export type { 
    UserCredentials as Credentials , 
    UserAuthState as AuthState, 
    RegisterData as Register  };