import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from './useAuth';
import { getMyProfile } from "../services/Profile/profileService";
import { isTokenExpired } from "../services/Auth/authService";

export default function useAuthGuard(setProfile?: (profile: any) => void) {
    const navigate = useNavigate();

     useEffect(() => {
        const interval = setInterval(() => {
        const token = useAuth.getState().token;

        if (token && isTokenExpired(token)) {
                useAuth.getState().signOut();
                navigate("/");
        }}, 120 * 1000);

        return () => clearInterval(interval);
    }, []);


    useEffect(() => {
        getMyProfile()
            .then(setProfile)
            .catch((err) => {
                console.error("Error loading profile:", err);
                useAuth.getState().signOut();
                navigate("/");
            });
    }, []);
};