import React, { useState, useEffect } from "react";
import { Button, Form, Heading, TextField } from "react-aria-components";
import { Input } from "../Accesible_Assets/Input";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import { passwordRequest } from "../../../services/Auth/passwordResetService"
import SentIcon from "../../components/Utils/AnimIcons/SentIcon";
import "../../../styles/components/Auth/ForgotPassword.scss";
import { useTranslation } from "react-i18next";
import ErrorIcon from "../Utils/AnimIcons/ErrorIcon";

interface ForgotPasswordProps {
    onClose: () => void;
}

function ForgotPassword ({ onClose }: ForgotPasswordProps) {
    const [email, setEmail] = useState("");
    const [error, setError] = useState("");
    const [message, setMessage] = useState("");
    const { t } = useTranslation("reset");

    useEffect(() => {
        document.body.classList.add("disable-navbar-click");
        return () => document.body.classList.remove("disable-navbar-click");
    }, []);

    const handleReset = async (e: React.FormEvent) => {
        e.preventDefault();
        e.stopPropagation();
        setMessage("");
        setError("");

        try {
            const data = await passwordRequest(email);
            setMessage(data.message || t("reset.success"));
            setError("");
            
            setTimeout(() => { 
                onClose(); 
                setEmail(''); 
                setMessage('');}, 8000);                     
        } catch (err: any) {
            setError(err.message || t("reset.error"));
            setMessage('');
        }
    };

    return (
        <Form onSubmit={handleReset}>
            <Heading slot="title" aria-label={t("reset.title")} 
            className="modal-title">{t("reset.title")}</Heading>
            <TextField aria-label="email" type="email" 
                value={email} onChange={setEmail}>
                {message && !error && (
                    <div className="feedback-success">
                        <p
                        className="feedback-message"
                        aria-label="success-message"
                        >{message}</p>
                        <SentIcon
                        className="sent-icon"
                        loop={true} 
                        completed={true}
                        size={70}
                        />
                    </div>
                )}
                {error && 
                    <div className="feedback-error-container">
                        <p 
                        className="feedback-error"
                        >{error}</p>
                        <ErrorIcon
                            completed={true}
                            size={75}
                        />
                    </div>
                }
                 {(!message || error) && (
                    <Input
                        placeholder={t("reset.email")}
                        name="email"
                        type="email"
                        value={email}
                        aria-label={t("reset.email")}
                        onChange={(e: any) => setEmail(e.target.value)}
                    />
                 )}
            </TextField>
            
            <div className="modal-actions">
                 {!message && <SubmitButton>{t("reset.send")}</SubmitButton> }
                 
                <Button 
                    className="cancel-btn"
                    aria-label={t("reset.cancel")}
                    onPress={() => { 
                        setEmail('');
                        setMessage(''); 
                        setError(''); 
                        onClose(); }}>{t("reset.cancel")}
                </Button>
            </div>
        </Form>
    );
}

export { ForgotPassword };