import React, { useState, useRef } from "react";
import { Input } from "../Accesible_Assets/Input";
import { PasswordInput } from "../Accesible_Assets/PasswordInput";
import { Checkbox } from "../Accesible_Assets/Checkbox";
import { SubmitButton } from "../Accesible_Assets/SubmitButton"
import { Omniauth } from "../Accesible_Assets/Onmniauth";
import { DialogComponent } from "../Accesible_Assets/Dialog";
import { TriggerButton } from "../Accesible_Assets/TriggerButton";
import { ForgotPassword } from "../Auth/ForgotPassword";
import { signIn } from "../../../services/authService";
import { useAuth } from "../../../stores/useAuth";
import { useNavigate } from "react-router-dom";
import "../../../styles/components/Auth/SignIn.scss";

export default function SignIn() {
  const { setUser } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const formRef = useRef(null);
  const [agree, setAgree] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const { token, user } = await signIn({
        email, 
        password, 
        rememberMe: agree
      });
      if (token && user) {
        setUser(user, token);
        navigate("/profiles");
        alert("Login OK");
      }
    } catch (err) {
      console.error(err);
      alert("Login failed");
    }
  };

  const close = () => {
    setEmail("");
    setPassword("");
    setAgree(false);
    if (formRef.current) {
      (formRef.current as HTMLFormElement).reset();
    }
  };

  // const handleForgotPassword = async (email: string) => {
  //   try {
  //     await forgotService(email); // tu endpoint real
  //     alert("Recovery email sent");
  //   } catch (err) {
  //     console.error(err);
  //     alert("Error sending recovery email");
  //   }
  // };

  return (
    <form ref={formRef} onSubmit={handleSubmit} className="sign-in-form">
      <h2 className="form-title">LOGIN</h2>

      <Input
        placeholder="Email"
        name="email"
        type="email"
        value={email}
        aria-label="Email input"
        onChange={(e: any) => setEmail(e.target.value)}
      />

      <PasswordInput
        placeholder="Password"
        name="password"
        type="password"
        aria-label="Password input"
        value={password}
        onChange={(e: any) => setPassword(e.target.value)}
      />

      <Checkbox
        name="remember_me"
        label="Remember me"
        aria-label="Remember me checkbox"
        checked={agree}
        onChange={(e) => setAgree(e.target.checked)}
      />

      <SubmitButton>Login</SubmitButton>

      <DialogComponent
        trigger={<TriggerButton>Forgot password?</TriggerButton>}
        ariaLabel="Forgot password dialog"
        isDismissable={true}
      >
        {({}) => (
          <ForgotPassword onClose={close} />
        )}
      </DialogComponent>

      <div className="gradient-line" />
      <Omniauth
        text="Or login with"  
      />
    </form>
  );
}