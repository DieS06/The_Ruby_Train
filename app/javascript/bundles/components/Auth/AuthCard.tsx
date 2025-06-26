import React, { useState, useRef, useEffect } from "react";
import SignInForm from "./SignIn";
import SignUpForm from "./SignUp";
import BGLoginShape from "../../components/Shapes/BGLoginShape";
import "../../../styles/components/Auth/AuthCard.scss";
import { useAuth } from "../../../stores/useAuth";

export default function AuthCard() {
  const [ isSignUp, setIsSignUp ] = useState(false);
  const firstSignUpFieldRef = useRef<HTMLInputElement>(null);
  const { user } = useAuth();

  useEffect(() => {
    const handler = (e: CustomEvent) => {
      setIsSignUp(e.detail === "signUp");
    };
    window.addEventListener("auth-toggle", handler as EventListener);
    return () => window.removeEventListener("auth-toggle", handler as EventListener);
  }, []);

  useEffect(() => {
    if (isSignUp && firstSignUpFieldRef.current) {
      firstSignUpFieldRef.current.focus();
    }
  }, [isSignUp]);

  if (user) return null;

  return (
    <div className="auth-container">
        <BGLoginShape/>
      <div className={`auth-form-wrapper ${isSignUp ? 'sign-up-active' : ''}`}>
          <div className="form-panel sign-in-panel" aria-hidden={isSignUp}>
            <SignInForm />
          </div>
          <div className="form-panel sign-up-panel" aria-hidden={!isSignUp}>
            <SignUpForm />
          </div>
      </div> 
    </div>
  );
}