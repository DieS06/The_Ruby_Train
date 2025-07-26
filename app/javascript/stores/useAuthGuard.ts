import { useEffect, useState } from 'react';
import { useAuth } from './useAuth';

interface AuthGuardResult {
    isAuthenticated: boolean;
    isAuthChecking: boolean;
}

export default function useAuthGuard(): AuthGuardResult {
    const { signOut, user } = useAuth.getState();
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [isAuthChecking, setIsAuthChecking] = useState(true);

    useEffect(() => {
        const checkAuthStatus = () => {
        if (user) {
            setIsAuthenticated(true);
        } else {
            setIsAuthenticated(false);
            signOut();
        }
        setIsAuthChecking(false);
        };

        checkAuthStatus();

        return () => {
        };
    }, [user, signOut]);

    return { isAuthenticated, isAuthChecking }
};