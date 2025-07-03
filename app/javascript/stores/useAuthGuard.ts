import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from './useAuth';
import { isTokenExpired } from "../services/Auth/authService";

interface AuthGuardResult {
    isAuthenticated: boolean;
    isAuthChecking: boolean;
}

export default function useAuthGuard(): AuthGuardResult {
    const navigate = useNavigate();
    const { token, signOut, user } = useAuth.getState();

    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [isAuthChecking, setIsAuthChecking] = useState(true);

     useEffect(() => {
        const checkAuthStatus = () => {
            if(token && user) {
                if (!isTokenExpired(token)) {
                    setIsAuthenticated(true);
                } else {
                    signOut();
                    setIsAuthenticated(false);
                }
            } else {
                setIsAuthenticated(false);
            }
            setIsAuthChecking(false);
        };

        checkAuthStatus();

        const interval = setInterval(() => {
            const currentToken = useAuth.getState().token;
            if (currentToken && isTokenExpired(currentToken)) {
                    signOut();
                    navigate("/");
            }}, 120 * 1000);

        return () => clearInterval(interval);
    }, [token, user, signOut, navigate]);
    
    return { isAuthenticated, isAuthChecking}
};