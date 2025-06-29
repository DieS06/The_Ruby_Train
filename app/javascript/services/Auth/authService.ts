import { useAuth } from "../../stores/useAuth";
import { Credentials } from "../../types/Auth/Credentials";
import { Register } from "../../types/Auth/Register";
import { BEErrors as RailsErrorsType, RegisterResponse } from "../../types/Auth/Errors";
import { CustomAuthError } from "../../types/Auth/CustomAuthError";
import api from "../Axios/axios";

const processAndThrowAuthError = (error: any, defaultMessage: string): never => {
  const backendResponseData: RailsErrorsType | undefined = error?.response?.data;
  const processedMessages: string[] = [];

  if (backendResponseData?.errors) {
    for (const field in backendResponseData.errors) {
      if (backendResponseData.errors.hasOwnProperty(field)) {
        const fieldErrors = backendResponseData.errors[field];
        const formattedField = field.replace(/_/g, ' ').replace(/\b\w/g, char => char.toUpperCase());

        if (Array.isArray(fieldErrors)) {
          fieldErrors.forEach(msg => { processedMessages.push(`${formattedField}: ${msg}`); });
        } else if (typeof fieldErrors === 'string') {
          processedMessages.push(`${formattedField}: ${fieldErrors}`);
        }
      }
    }
  } else if (backendResponseData?.error) {
    processedMessages.push(backendResponseData.error);
  } else if (backendResponseData?.message) {
    processedMessages.push(backendResponseData.message);
  } else if (error.message) {
    processedMessages.push(error.message); // Errores de Axios/red
  }

  const finalMessage = processedMessages.length > 0 ? processedMessages.join(". ") : defaultMessage;

  // Lanzar CustomAuthError con el array de errores
  throw new CustomAuthError(finalMessage, processedMessages);
};

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

const signUp = async (register: Register): Promise<RegisterResponse> => { 
  try {
    const response = await api.post("/users", register, {
       headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    });

    return { message: response.data.message || "Registration successful" };
  } catch (error: any) {
    console.error("Registration error:", error);

    const backendResponseData: RailsErrorsType | undefined = error?.response?.data;
    let errorMessage: string = "Registration failed. Please try again.";

    if (backendResponseData?.errors) {
      const fieldErrorMessages: string[] = [];
      for (const field in backendResponseData.errors) {
        if (backendResponseData.errors.hasOwnProperty(field)) {
          const fieldErrors = backendResponseData.errors[field];
          const formattedField = field.replace(/_/g, ' ').replace(/\b\w/g, char => char.toUpperCase());

          if (Array.isArray(fieldErrors)) {
            fieldErrors.forEach(msg => {
              fieldErrorMessages.push(`${formattedField}: ${msg}`);
            });
          } else if (typeof fieldErrors === 'string') {
            fieldErrorMessages.push(`${formattedField}: ${fieldErrors}`);
          }
        }
      }
      if (fieldErrorMessages.length > 0) {
        errorMessage = fieldErrorMessages.join(". ");
      }
    } else if (backendResponseData?.errors) {
      errorMessage = JSON.stringify(backendResponseData.errors);
    } else if (backendResponseData?.message) {
      errorMessage = backendResponseData.message;
    } else if (error.message) {
      errorMessage = error.message;
    }

    if (error.response && error.response.status === 422 && errorMessage === "Registration failed. Please try again.") {
      errorMessage = "Validation failed. Please check your input.";
    }

    throw new Error(errorMessage);
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