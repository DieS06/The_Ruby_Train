interface SignInResponse {
  token: string | undefined;
  user: any;
}

const signIn = async (email: string, password: string, rememberMe: boolean): Promise<SignInResponse> => {
  const response = await fetch("/users/sign_in", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ user: { email, password, rememberMe: rememberMe, } }),
  });

  if (!response.ok) throw new Error("Invalid credentials");

  const token = response.headers.get("Authorization")?.split(" ")?.[1];
  const data = await response.json();
  console.log(data);
  
  return { token, user: data };
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
