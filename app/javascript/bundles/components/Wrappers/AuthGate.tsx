import React, { useEffect, useState } from 'react';
import { visit } from "@hotwired/turbo";
import { jwtDecode } from 'jwt-decode'
import useAuthGuard from '@/stores/useAuthGuard';
import { useAuth } from '@/stores/useAuth'
import SessionExpiredDialog from '../Auth/SessionExpiredDialog';

interface Props {
  children: React.ReactNode;
}

const AuthGate: React.FC<Props> = ({ children }) => {
  const { isAuthenticated, isAuthChecking } = useAuthGuard();
  const { signOut } = useAuth();
  const [dialogOpen, setDialogOpen] = useState(false);

  useEffect(() => {
    const cookies = document.cookie.split(';')
    const token = cookies
      .map(c => c.trim())
      .find(c => c.startsWith('access_token='))
      ?.split('=')[1]

    if (token) {
      try {
        const { exp } = jwtDecode<{ exp: number }>(token)
        if (Date.now() >= exp * 1000) {
          signOut()
          setDialogOpen(true)
        }
      } catch {
        signOut()
        setDialogOpen(true)
      }
    }
  }, [])

  useEffect(() => {
    if (!isAuthChecking && !isAuthenticated && !dialogOpen) {
      visit("/");
    }
  }, [isAuthChecking, isAuthenticated]);

  if (isAuthChecking) {
    return <div className="loading-screen">Checking authentication...</div>;
  }

  return <>
    <SessionExpiredDialog open={dialogOpen} onClose={() => setDialogOpen(false)} />
    {isAuthenticated && children}
  </>;
};

export default AuthGate;