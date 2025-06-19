import React, { useState, useRef, useEffect } from "react";
import SignInForm from "./SignIn";
import SignUpForm from "./SignUp";
import BGLoginShape from "../../components/Shapes/BGLoginShape";
import "../../../styles/components/Auth/AuthCard.scss";

export default function AuthCard() {
  const [ isSignUp, setIsSignUp ] = useState(false);
  const firstSignUpFieldRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (isSignUp && firstSignUpFieldRef.current) {
      firstSignUpFieldRef.current.focus();
    }
  }, [isSignUp]);


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
          <div className="auth-toggle">
            {!isSignUp ? (
              <button onClick={() => setIsSignUp(true)}>Sign Up</button>
            ) : (
              <button onClick={() => setIsSignUp(false)}>Sign In</button>
            )}
          </div>
        </div>
    </div>
  );
}