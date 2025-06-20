import { fetchWithAuth } from "./fetchWithAuth";

export const getMyProfile = async () => {
  const response = await fetchWithAuth("/profiles/me");
  if (!response.ok) throw new Error("Failed to fetch profile");
  return await response.json();
};

export const updateMyProfile = async (profileData: any) => {
  const response = await fetchWithAuth("/profiles/me", {
    method: "PUT",
    body: JSON.stringify({ profile: profileData }),
  });
  if (!response.ok) throw new Error("Failed to update profile");
  return await response.json();
};

export const getProfileById = async (id: string) => {
  const response = await fetchWithAuth(`/profiles/${id}`);
  if (!response.ok) throw new Error("Failed to fetch profile by ID");
  return await response.json();
}