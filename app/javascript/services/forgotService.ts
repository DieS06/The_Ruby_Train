interface SignInResponse {
  token: string | undefined;
  user: any;
}

const forgotPassword = async (email: string): Promise<SignInResponse> => {
  const response = await fetch("/users/sign_in", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ user: { email } }),
  });

  if (!response.ok) throw new Error("Invalid credentials");

  const token = response.headers.get("Authorization")?.split(" ")?.[1];
  const data = await response.json();
  console.log(data);
  
  return { token, user: data };
};