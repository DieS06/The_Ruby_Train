import React, { useState } from "react";
import { toastAlert } from "../../Utils/toasts";
import { SubmitButton } from '../../Accesible_Assets/SubmitButton';
import { PasswordInput } from '../../Accesible_Assets/PasswordInput';

const FormPasswordChange: React.FC = () => {
    const [password, setPassword] = useState("");

    return (
        <form className="password-form">
            <PasswordInput
              name="current_password"
              value=''
              placeholder="Current Password"
              aria-label="Current Password"
              required={true}
              onChange={(e: any) => setPassword(e.target.value)}
            />
            <PasswordInput
              name="new_password"
              value=''
              placeholder="New Password"
              aria-label="New Password"
              required={true}
              onChange={(e: any) => setPassword(e.target.value)}
            />
            <PasswordInput
              name="confirm_new_password"
              value=''
              placeholder="Confirm New Password"
              aria-label="Confirm New Password"
              required={true}
              onChange={(e: any) => setPassword(e.target.value)}
            />
            <SubmitButton>Change Password</SubmitButton>
        </form>
    );
}

export default FormPasswordChange;