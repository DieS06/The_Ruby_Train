import React, { useState, useRef, useEffect } from "react";
import { Input } from "../Accesible_Assets/Input";
import { PasswordInput } from "../Accesible_Assets/PasswordInput";
import { Checkbox } from "../Accesible_Assets/Checkbox";
import { SubmitButton } from "../Accesible_Assets/SubmitButton"
import { DialogComponent } from "../Accesible_Assets/Dialog";
import { TriggerButton } from "../Accesible_Assets/TriggerButton";
import { ForgotPassword } from "../Auth/ForgotPassword";
import { signIn } from "@services/Auth/authService";
import { useAuth } from "@stores/useAuth";
import "@styles/components/Auth/SignIn.scss";
import { toastAlert } from "../Utils/toasts";
import { useTranslation } from "react-i18next"

export default function SignIn() {
  const { setUser } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const formRef = useRef(null);
  const [agree, setAgree] = useState(false);
  const [showResetDialog, setShowResetDialog] = useState(false);
  const { t } = useTranslation(["login", "common"]);

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
      }
    } catch (err: any) {
      const fallback = t("alerts.login_failed", {ns: "common"});
      toastAlert.error(t(fallback), {
          autoClose: 3000,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true
        });
    }
  };

  useEffect(() => {
    const savedEmail = localStorage.getItem("rememberedEmail");
    if (savedEmail) setEmail(savedEmail);
  }, []);

  const close = () => {
    setEmail("");
    setPassword("");
    setAgree(false);
    if (formRef.current) {
      (formRef.current as HTMLFormElement).reset();
    }
  };

  return (
    <>
      <form ref={formRef} onSubmit={handleSubmit} className="sign-in-form">
        <h2 className="form-title">{t("login.title")}</h2>

        <Input
          placeholder={t("login.email")}
          name="email"
          type="email"
          value={email}
          aria-label={t("login.email")}
          onChange={(e: any) => setEmail(e.target.value)}
        />

        <PasswordInput
          placeholder={t("login.password")}
          name="password"
          type="password"
          aria-label={t("login.password")}
          value={password}
          onChange={(e: any) => setPassword(e.target.value)}
        />

        <Checkbox
          name={t("login.remember_me")}
          label={t("login.remember_me")}
          aria-label={t("login.remember_me")}
          checked={agree}
          onChange={(e) => setAgree(e.target.checked)}
        />

        <SubmitButton>{t("login.submit_button")}</SubmitButton>
      </form>

      <section className="actions">
      <DialogComponent
          isOpen={showResetDialog}
          onOpenChange={setShowResetDialog}
          trigger={<TriggerButton onClick={() => setShowResetDialog(true)}>
          {t("login.forgot_password")}
          </TriggerButton>}
          ariaLabel={t("login.forgot_password")}
          isDismissable={true}
        >
          {({}) => (
            <ForgotPassword onClose={() => setShowResetDialog(false)} />
          )}
        </DialogComponent>

        {/* <div className="gradient-line" />
        <Omniauth
          text={t("login.omniauth")}
        /> */}
        </section>
    </>
  );
}