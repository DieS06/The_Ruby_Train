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
import { toastAlert } from "../Utils/toasts"

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
    const { name, value, type, checked } = e.target;
    setForm(prevForm => ({ ...prevForm, [name]: type === 'checkbox' ? checked : value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
     e.preventDefault();

    if (!form.agree) {
      toastAlert.info(t("register.terms_info"), { position: "top-center" });
      return;
    }

    try {
      await signUp(registerData);
      toastAlert.success(t("register.success"), { position: "top-center" });

      setForm({
        first_name: "", last_name: "", country: "", phone_number: "", email: "",
        password: "", password_confirmation: "", agree: false,
      });
    } catch (err: any) {
      console.error("Frontend registration error:", err);
      toastAlert.error(err.message || t("register.failed"), { position: "top-center" });
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
        onChange={
          (countryName) => {
            console.log("Country code received:", countryName);
            setForm({...form, country: countryName})
          }}
      />

      <PhoneInput
        aria-label={t("register.phone_number")}
        value={form.phone_number}
        placeholder={t("register.phone_number")}
        name="phone_number"
        onChange={(value) => {
          console.log("Phone number received:", value); 
          setForm(prevForm => ({...prevForm, phone_number: value || ""}));
        }}
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
        name="agree"
        label={t("register.terms_and_conditions")}
        aria-label={t("register.terms_and_conditions")}
        checked={form.agree}
        onChange={ handleInputChange }
        required
      />
      
      <SubmitButton 
        isLogicallyDisabled={!form.agree}
        onClick={handleSubmit}  
      >
        {t("register.submit_button")}
      </SubmitButton>

      {/* <Omniauth
        text={t("register.omniauth")}
      /> */}
    </form>
  );
}
