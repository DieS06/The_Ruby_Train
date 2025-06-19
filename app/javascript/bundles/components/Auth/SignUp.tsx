import React, { useState } from "react";
import { Input } from "../Accesible_Assets/Input";
import { CountryInput } from "../Accesible_Assets/CountryInput";
import { Country } from "react-phone-number-input";
import { PhoneInput } from "../Accesible_Assets/PhoneInput";
import { PasswordInput } from "../Accesible_Assets/PasswordInput";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import { Checkbox } from "../Accesible_Assets/Checkbox";
import { Omniauth } from "../Accesible_Assets/Onmniauth";
import { useAuth } from "../../../stores/useAuth";
import { signUp } from "../../../services/authService";
import "../../../styles/components/Auth/SignUp.scss";


export default function SignUp() {
  const { setUser } = useAuth();
  const [agree, setAgree] = useState(false);
  const [form, setForm] = useState<{
    first_name: string;
    last_name: string;
    country: Country | string;
    phone_number: string;
    email: string;
    password: string;
    password_confirmation: string;
  }>(
    {
      first_name: "",
      last_name: "",
      country: "" ,
      phone_number: "",
      email: "",
      password: "",
      password_confirmation: "",
    }
  );

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const { token, user } = await signUp(form.email, form.password,
        form.password_confirmation);
      if (token && user) {
        setUser(user, token);
        // redirigir o cerrar panel si querés
      }
    } catch (err) {
      console.error(err);
      alert("Registro fallido");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="sign-up-form">
      <h2 className="form-title">REGISTER</h2>

      <Input
        aria-label="First Name"
        placeholder="First Name"
        name="first_name"
        type="first_name"
        value={form.first_name}
        onChange={(e: any) => setForm(e.target.value)}
      />

      <Input
        aria-label="Last Name"
        placeholder="Last Name"
        name="last_name"
        type="last_name"
        value={form.last_name}
        onChange={(e: any) => setForm(e.target.value)}
      />

      <CountryInput
        aria-label="Country"
        value={form.country}
        onChange={((code) => setForm({...form, country: code}))}
      />

      <PhoneInput
        aria-label="Phone Number"
        value={form.phone_number}
        placeholder="Phone Number"
        name="phone_number"
        onChange={(value) => setForm({...form, phone_number: value || ""})}
      />

      <Input
        aria-label="Email"
        placeholder="Email"
        name="email"
        type="email"
        value={form.email}
        onChange={(e: any) => setForm(e.target.value)}
      />

      <PasswordInput
        aria-label="Password"
        placeholder="Password"
        name="password"
        type="password"
        value={form.password}
        onChange={(e: any) => setForm(e.target.value)}
      />

      <PasswordInput
        aria-label="Confirm Password"
        placeholder="Confirm Password"
        name="password_confirmation"
        type="password"
        value={form.password_confirmation}
        onChange={(e: any) => setForm(e.target.value)}
      />

      <Checkbox
        name="I agree to the terms and conditions"
        label="I agree to the terms and conditions"
        aria-label="I agree to the terms and conditions"
        checked={agree}
        onChange={(e) => setAgree(e.target.checked)}
      />
      
      <SubmitButton>Register</SubmitButton>

      <Omniauth
        text="Or continue with"
      />
    </form>
  );
}
