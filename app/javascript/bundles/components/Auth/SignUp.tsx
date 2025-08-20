import React, { useState } from "react";
import { Input } from "../Accesible_Assets/Input";
import { CountryInput } from "../Accesible_Assets/CountryInput";
import { PhoneInput } from "../Accesible_Assets/PhoneInput";
import { PasswordInput } from "../Accesible_Assets/PasswordInput";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import { Checkbox } from "../Accesible_Assets/Checkbox";
import { signUp } from "../../../services/Auth/authService";
import type { RegisterData } from "../../../types/Auth/AuthState";
import "../../../styles/components/Auth/SignUp.scss";
import { useTranslation } from "react-i18next";
import { toastAlert } from "../Utils/toasts"
import { DialogComponent } from "../Accesible_Assets/Dialog";
import { CountryCode } from "libphonenumber-js/min";

export default function SignUp() {
  const { t } = useTranslation("register");
  const [ modelOpen, setModelOpen ] = useState(false);
  const [countryCode, setCountryCode] = useState<CountryCode>("CR");
  const [form, setForm] = useState<RegisterData & { agree: boolean }>({
      first_name: "",
      last_name: "",
      email: "",
      country: "",
      phone_number: "",
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
      toastAlert.info(t("register.terms_info"));
      return;
    }

    try {
      await signUp(registerData);
      setModelOpen(true);
      setForm({
        first_name: "", last_name: "", country: "", phone_number: "", email: "",
        password: "", password_confirmation: "", agree: false,
      });
    } catch (err: any) {
      toastAlert.error(err.message || t("register.failed"));
    }
  };

  return (
    <>
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
            (countryName, code) => {
              setCountryCode(code as CountryCode);
              setForm({...form, country: countryName})
            }}
        />

        <PhoneInput
          aria-label={t("register.phone_number")}
          value={form.phone_number}
          placeholder={t("register.phone_number")}
          name="phone_number"
          defaultCountry={countryCode}
          onChange={(value) => {
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
      </form>

      <DialogComponent
        trigger={<button style={{ display: "none" }}></button>}
        isOpen={modelOpen}
        onOpenChange={setModelOpen}
      >
        {(close) => (
          <>
            <h3>{t("register.success")}</h3>
            <p>{t("register.success_message")}</p>
            <SubmitButton onClick={close}>{t("register.close")}</SubmitButton>
          </>
        )}
      </DialogComponent>
    </>
  );
}
