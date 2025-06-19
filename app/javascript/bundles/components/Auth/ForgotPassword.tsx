import React, { useState } from "react";
import { Heading, Form, TextField, Button } from "react-aria-components";
import { Input } from "../Accesible_Assets/Input";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import "../../../styles/components/Auth/ForgotPassword.scss";

interface ForgotPasswordProps {
    onClose: () => void;
}

function ForgotPassword ({ onClose }: ForgotPasswordProps) {
    const [email, setEmail] = useState("");
    const [error, setError] = useState("");
    const [message, setMessage] = useState("");

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setMessage("");
        setError("");

        try {
        const response = await fetch("/users/password", {
            method: "POST",
            headers: { "Content-Type": "application/json", Accept: "application/json" },
            body: JSON.stringify({ user: { email } }),
        });

        if (response.ok) {
            const data = await response.json();
            setMessage(data.message || "Password retrieval instructions sended.");
            // Opcional: Podrías cerrar el modal automáticamente después de un éxito.
            // setTimeout(onClose, 3000); 
        } else {
            const errorData = await response.json();
            setError(errorData.errors ? errorData.errors.join(", ") : "Error sending instructions.");
        }
        } catch (err) {
        console.error(err);
        setError("Connection error. Try again.");
        }
    };

    return (
        <Form onSubmit={handleSubmit}>
            <Heading slot="title" className="modal-title">Reestablish your password!</Heading>
            <TextField type="email" value={email} onChange={setEmail}>
                <Input
                    placeholder="Insert your email"
                    name="email"
                    type="email"
                    value={email}
                    aria-label="Email input"
                    onChange={(e: any) => setEmail(e.target.value)}
                />
            </TextField>
            {message && <p style={{ color: "green" }}>{message}</p>}
            {error && <p style={{ color: "red" }}>{error}</p>}
            <div className="modal-actions">
                <SubmitButton>Send</SubmitButton>
                <Button onPress={() => { setEmail(''); setMessage(''); setError(''); onClose(); }}>Cancel</Button>
            </div>
        </Form>
    );
}

export { ForgotPassword };