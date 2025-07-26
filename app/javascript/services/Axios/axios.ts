import axios from 'axios';
import { useAuth } from "../../stores/useAuth";

const api = axios.create({
  baseURL: "http://localhost:3000",
  withCredentials: true,
  headers: {
    "Content-Type": "application/json",
    Accept: "application/json",
  },
});

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