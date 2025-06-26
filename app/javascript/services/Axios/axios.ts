import axios from 'axios';
import { useAuth } from "../../stores/useAuth";
import { isTokenExpired } from '../Auth/authService';

const api = axios.create({
  baseURL: "http://localhost:3000",
});

api.interceptors.request.use(
  (config) => {
    const token = useAuth.getState().token;
    
    if (token) {
      if (isTokenExpired(token)) {
        useAuth.getState().signOut();
        return Promise.reject(new Error("Token expired, please sign in again.")); 
      }
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  }, (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (resp) => resp,
  (err)=> {
    if(err.response?.status === 401) useAuth.getState().signOut();
    return Promise.reject(err);
  }
);

export default api;