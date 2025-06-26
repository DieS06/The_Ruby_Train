import React, { useState } from "react";
import { Input } from "../Accesible_Assets/Input";
import { CountryInput } from "../Accesible_Assets/CountryInput";
import { PhoneInput } from "../Accesible_Assets/PhoneInput";
import { PasswordInput } from "../Accesible_Assets/PasswordInput";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import { Checkbox } from "../Accesible_Assets/Checkbox";
import { Omniauth } from "../Accesible_Assets/Onmniauth";
import { useAuth } from "../../../stores/useAuth";
import { signUp } from "../../../services/Auth/authService";
import type { Register } from "../../../types/Auth/Register";
import "../../../styles/components/Auth/SignUp.scss";
import { useTranslation } from "react-i18next";
import { alert } from "../Utils/toasts"

export default function SignUp() {
  const { t } = useTranslation("register");
  const { setUser } = useAuth();
  const [form, setForm] = useState<Register & { agree: boolean }>({
      first_name: "",
      last_name: "",
      country: "" ,
      phone_number: "",
      email: "",
      password: "",
      password_confirmation: "",
      agree: false,
    }
  );
  const { agree, ...registerData } = form;

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!form.agree) {
      alert.info(t("register.terms_info"));
      return;
    }

    try {
      const { token, user } = await signUp( registerData);
      if (token && user) {
        setUser(user, token);
        alert.success(t("register.success"));
      }
    } catch (err) {
      console.error("Frontend registrarion error:", err);
      alert.error(t("register.failed."));
    }
  };

  

  return (
    <form onSubmit={handleSubmit} className="sign-up-form">
      <h2 className="form-title">{t("register.title")}</h2>

      <Input
        aria-label={t("register.first_name")}
        placeholder={t("register.first_name")}
        name="first_name"
        type="text"
        value={form.first_name}
        onChange={ handleInputChange }
      />

      <Input
        aria-label={t("register.last_name")}
        placeholder={t("register.last_name")}
        name="last_name"
        type="text"
        value={form.last_name}
        onChange={ handleInputChange }
      />

      <CountryInput
        aria-label={t("register.country")}
        value={form.country}
        onChange={((code) => setForm({...form, country: code}))}
      />

      <PhoneInput
        aria-label={t("register.phone_number")}
        value={form.phone_number}
        placeholder={t("register.phone_number")}
        name="phone_number"
        onChange={(value) => setForm({...form, phone_number: value || ""})}
      />

      <Input
        aria-label={t("register.email")}
        placeholder={t("register.email")}
        name="email"
        type="email"
        value={form.email}
        onChange={ handleInputChange }
      />

      <PasswordInput
        aria-label={t("register.password")}
        placeholder={t("register.password")}
        name="password"
        type="password"
        value={form.password}
        onChange={ handleInputChange }
        required
      />

      <PasswordInput
        aria-label={t("register.confirm_password")}
        placeholder={t("register.confirm_password")}
        name="password_confirmation"
        type="password"
        value={form.password_confirmation}
        onChange={ handleInputChange }
        required
      />

      <Checkbox
        name={t("register.terms_and_conditions")}
        label={t("register.terms_and_conditions")}
        aria-label={t("register.terms_and_conditions")}
        checked={form.agree}
        onChange={(e: any) => setForm({...form, agree: e.target.checked})}
        required
      />
      
      <SubmitButton disabled={!form.agree}>{t("register.submit_button")}</SubmitButton>

      <Omniauth
        text={t("register.omniauth")}
      />
    </form>
  );
}
