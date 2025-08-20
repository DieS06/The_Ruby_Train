import { useEffect, useState } from 'react';
import { useAuth } from './useAuth';

interface AuthGuardResult {
    isAuthenticated: boolean;
    isAuthChecking: boolean;
}

export default function useAuthGuard(): AuthGuardResult {
    const  user  = useAuth((s) => s.user);
    const signOut = useAuth((s) => s.signOut);
    const [isAuthChecking, setIsAuthChecking] = useState(true);
    const isAuthenticated = Boolean(user);

    useEffect(() => {
     if (!user) signOut()
        setIsAuthChecking(false)
    }, [user, signOut])

  return { isAuthenticated, isAuthChecking }
};