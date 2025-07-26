import React, { useEffect } from 'react';
import { visit } from "@hotwired/turbo";
import useAuthGuard from '@/stores/useAuthGuard';
import type { Props } from '@/types/Children';

const AuthGate: React.FC<Props> = ({ children }) => {
  const { isAuthenticated, isAuthChecking } = useAuthGuard();

  useEffect(() => {
    if (!isAuthChecking && !isAuthenticated) {
      visit("/");
    }
  }, [isAuthChecking, isAuthenticated]);

  if (isAuthChecking) {
    return <div className="loading-screen">Checking authentication...</div>;
  }

  if (!isAuthenticated) {
    visit("/");
    return <div className="loading-screen">Redirecting...</div>;
  }

  return <>{children}</>;
};

export default AuthGate;