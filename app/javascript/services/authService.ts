import { useAuth } from "../stores/useAuth";
import { Credentials } from "../types/UserCredentials";

const signIn = async (credentials: Credentials) => {
  const response = await fetch("/users/sign_in", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ user: credentials }),
  });

  if (!response.ok) throw new Error("Invalid credentials");

  const data = await response.json();
  const token = data.token;
  const user = data.user;
  console.log(data);
  
  const minimalUser: Credentials = {
    email: user.email,
    state: user.state,
    rememberMe: credentials.rememberMe,
  };

  useAuth.getState().setUser(minimalUser, token);

  return { token, user: minimalUser };
};

const signUp = async (email: string, password: string, 
  passwordConfirmation: string) => {
  const response = await fetch("/users", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({
      user: { email, password, password_confirmation: passwordConfirmation },
    }),
  });

  if (!response.ok) throw new Error("Registration failed");

  const token = response.headers.get("Authorization")?.split(" ")?.[1];
  const data = await response.json();
  return { token, user: data };
};

export { signIn, signUp };
