import React, { useState } from "react";
import { toastAlert } from "../../Utils/toasts";
import { SubmitButton } from '../../Accesible_Assets/SubmitButton';
import { PasswordInput } from '../../Accesible_Assets/PasswordInput';
import { changeOwnPassword } from "@/services/Auth/authService";
import "@/styles/components/Profile/Forms/FormPasswordChange.scss";
import { set } from "zod";

const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{12,}$/;

const FormPasswordChange: React.FC = () => {
    const [currentPassword, setCurrentPassword] = useState("");
    const [newPassword, setNewPassword] = useState("");
    const [confirmation, setConfirmation] = useState("");
    const [loading, setLoading] = useState(false);

    const extractBackendErrors = (err: any): string[] => {
      const data = err?.response?.data;

      if (Array.isArray(data?.errors)) return data.errors;
      if (typeof data?.error === "string") return [data.error];
      if (typeof data?.message === "string") return [data.message];
      return [err?.message || "Unexpected error changing password"];
    };

    const validate = (): string[] => {
      const errors: string[] = [];
      if (!currentPassword || !newPassword || !confirmation) {
        errors.push("All fields are required");
        return errors; // no seguimos chequeando si está incompleto
      }
      if (newPassword === currentPassword) {
        errors.push("New password must be different from current password");
      }
      if (newPassword !== confirmation) {
        errors.push("New password and confirmation do not match");
      }
      if (!PASSWORD_REGEX.test(newPassword)) {
        errors.push("New password must be 12+ chars and include upper, lower, number, and one of !@#$%^&*");
      }
      return errors;
    };

    const handleSubmit = async (e: React.FormEvent) => {
      e.preventDefault();

      const localErrors = validate();
      if (localErrors.length) {
        toastAlert.error(localErrors.join(". "));
        return;
      }

      try {
        setLoading(true);

          await changeOwnPassword({
              current_password: currentPassword,
              password: newPassword,
              password_confirmation: confirmation,
          });

          toastAlert.success("Password updated successfully.");
          setCurrentPassword("");
          setNewPassword("");
          setConfirmation("");
        } catch (err: any) {
          const messages = extractBackendErrors(err);
          toastAlert.error([...new Set(messages)].join(".\n "));
        } finally {
          setLoading(false);
        }
    };

    return (
        <form onSubmit={handleSubmit} className="password-form">
            <PasswordInput
              name="current_password"
              value={currentPassword}
              type="password"
              placeholder="Current Password"
              aria-label="Current Password"
              required={true}
              onChange={(e: any) => setCurrentPassword(e.target.value)}
            />

            <PasswordInput
              name="new_password"
              value={newPassword}
              type="password"
              placeholder="New Password"
              aria-label="New Password"
              required={true}
              onChange={(e: any) => setNewPassword(e.target.value)}
            />

            <PasswordInput
              name="confirm_new_password"
              value={confirmation}
              type="password"
              placeholder="Confirm New Password"
              aria-label="Confirm New Password"
              required={true}
              onChange={(e: any) => setConfirmation(e.target.value)}
            />
            <SubmitButton>
              {loading ? "Saving..." : "Change Password"}
            </SubmitButton>
        </form>
    );
}

export default FormPasswordChange;