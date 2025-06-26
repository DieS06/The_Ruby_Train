import api from "../Axios/axios";

const getMyProfile = async () => {
  const response = await api.get("/profiles/me");
  return response.data;
};

const updateMyProfile = async (profileData: any) => {
  const response = await api.put("/profiles/me", {
    profile: profileData,
  });
  return response.data;
};

const getProfileById = async (id: string) => {
  const response = await api.get(`/profiles/${id}`);
  return response.data;
}

export {getMyProfile, updateMyProfile, getProfileById};