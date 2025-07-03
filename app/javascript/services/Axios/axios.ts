import axios from 'axios';
import { useAuth } from "../../stores/useAuth";
import { isTokenExpired } from '../Auth/authService';

const api = axios.create({
  baseURL: "http://localhost:3000",
  headers: {
    "Content-Type": "application/json",
  }
});

api.interceptors.request.use(
  (config) => {
    const { token } = useAuth.getState();
    
    if(token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

api.interceptors.response.use(
  (response) => response,
  (error)=> {
    if(error.response && error.response.status === 401) {
      useAuth.getState().signOut();
    }
    return Promise.reject(error);
  }
);

export default api;