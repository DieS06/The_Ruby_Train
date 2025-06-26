import api from "../Axios/axios";
import type { ResetResponse } from "../../types/Auth/ResetResponse";

const passwordRequest = async (email: string): Promise<ResetResponse> => {
  try {
    const response = await api.post("users/password", {
      user: { email },
    });
    return response.data;
  } catch (error: any) {
    const backendErrors = error?.response?.data?.errors;
    let errorMessage: string;

    if (backendErrors && Array.isArray(backendErrors) && backendErrors.length > 0) {
      errorMessage = backendErrors.join(", ");
    } else if (error.response?.data?.message) {
      errorMessage = error.response.data.message;
    } else if (error.message) {
      errorMessage = error.message;
    } else {
      errorMessage = "An unexpected error occurred.";
    }
    throw new Error(errorMessage);
  }
};

export { passwordRequest };