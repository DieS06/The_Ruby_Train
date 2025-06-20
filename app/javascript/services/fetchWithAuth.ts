import { useAuth } from "../stores/useAuth";

export const fetchWithAuth = async (url: string, options: RequestInit = {}) => {
  const token = useAuth.getState().token;

  const headers = {
    ...options.headers,
    Authorization: token ? `Bearer ${token}` : "",
    "Content-Type": "application/json",
    Accept: "application/json",
  };

  return fetch(url, {
    ...options,
    headers,
  });
};

// Usage example:
// const getProfile = async () => {
//   const response = await fetchWithAuth("/profiles/me");
//   if (!response.ok) throw new Error("Failed to fetch profile");
//   return await response.json();
// };