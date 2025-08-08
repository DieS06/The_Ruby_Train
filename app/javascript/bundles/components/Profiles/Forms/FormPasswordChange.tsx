import React, { useState } from "react";
import { toastAlert } from "../../Utils/toasts";
import { SubmitButton } from '../../Accesible_Assets/SubmitButton';
import { PasswordInput } from '../../Accesible_Assets/PasswordInput';
import { changeOwnPassword } from "@/services/Auth/authService";
import "@/styles/components/Profile/Forms/FormPasswordChange.scss";

const FormPasswordChange: React.FC = () => {
    const [currentPassword, setCurrentPassword] = useState("");
    const [newPassword, setNewPassword] = useState("");
    const [confirmation, setConfirmation] = useState("");

    const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
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
        toastAlert.error("Error updating password.");
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
            <SubmitButton>Change Password</SubmitButton>
        </form>
    );
}

export default FormPasswordChange;