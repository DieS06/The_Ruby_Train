import { useAuth } from "../../stores/useAuth";
import { Credentials } from "../../types/Auth/Credentials";
import { Register } from "../../types/Auth/Register";
import { Errors } from "../../types/Auth/RailsErrors";
import api from "../Axios/axios";

const signIn = async (credentials: Credentials) => {
 try {
    const response = await api.post("/users/sign_in", {
      user: credentials,
    });
    
    const {token, user } =response.data;

    const minimalUser: Credentials = {
      email: user.email,
      state: user.state,
      rememberMe: credentials.rememberMe,
    }

    if (credentials.rememberMe) {
      localStorage.setItem("rememberedEmail", credentials.email);
    } else {
      localStorage.removeItem("rememberedEmail");
    }
    

    useAuth.getState().setUser(minimalUser, token);
    return { token, user: minimalUser };

  } catch (error: any) {
    const msg = 
      error.response?.data?.error || 
      error.response?.data?.errors?.join(", ") ||
      "unknown";
    
    throw error;
  }
};

const signUp = async (register: Register) => { 
  try {
    const response = await api.post("/users", {
    user: register,
    });
    
    const token = response.headers.authorization?.split(" ")?.[1];
    const user = response.data.user;

    return { token, user };
  } catch (error: any) {
    console.error("Registration error:", error);

    const backendResponseData: Errors | undefined = error?.response?.data;
    let errorMessage: string = "Registration failed. Please try again.";

    if (backendResponseData?.errors) {
      const errorMessages: string[] = [];
      for (const field in backendResponseData.errors) {
        backendResponseData.errors[field].forEach(msg => {
          errorMessages.push(`${field.replace(/_/g, ' ')}: ${msg}`);
      });
    }
    errorMessage = errorMessages.length > 0 ? errorMessages.join(", ") : errorMessage;
    } else if (backendResponseData?.message) {
      errorMessage = backendResponseData.message;
    } else if (error.message) {
      errorMessage = error.message;
    }

    throw new Error("Registration failed");
  }
};

 function isTokenExpired(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return Date.now() >= payload.exp * 1000;
  } catch (err) {
    return true;
  }
}

export { signIn, signUp, isTokenExpired };