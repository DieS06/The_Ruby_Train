import React, { useState } from "react";
import { toastAlert } from "../../Utils/toasts";
import api from "@/services/Axios/axios";
import { Input } from "../../Accesible_Assets/Input";
import { PhoneInput } from "../../Accesible_Assets/PhoneInput";
import { CountryInput } from "../../Accesible_Assets/CountryInput";
import type { CountryCode } from 'libphonenumber-js';
import { SubmitButton } from "../../Accesible_Assets/SubmitButton";
import "@/styles/components/Profile/Forms/FormGeneral.scss";
import { set } from "zod";

interface Props {
  user: {
    first_name: string;
    last_name: string;
    email: string;
    phone_number: string;
    country: string;
    updated_at?: string;
  };
  onSuccess?: () => void;
}

const FormGeneral: React.FC<Props> = ({ user, onSuccess }) => {
    const [countryCode, setCountryCode] = useState<CountryCode | undefined>(undefined);
    const [formData, setFormData] = useState({
        ...user,
        firstName: user.first_name || "",
        lastName: user.last_name || "",
        phoneNumber: user.phone_number || "",
        country: user.country || "",
        email: user.email || "",
        updatedAt: user.updated_at || "",
    });

    const [isLoading, setIsLoading] = useState(false);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({ ...prevData, [name]: value }));
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setIsLoading(true);
        try {
            const payload: any = {
                user: {
                    first_name: formData.firstName,
                    last_name: formData.lastName,
                    phone_number: formData.phoneNumber,
                    country: formData.country,
                }
            };

            if (formData.email && formData.email !== user.email) {
                payload.user.email = formData.email;
            }

            const { data } = await api.put("/users/update_info", payload, {
                headers: { Accept: "application/json" }
            });

            if (data?.user?.updated_at) {
                setFormData(prev => ({
                    ...prev,
                    updatedAt: data.user.updated_at
                }));
            }

            if (data?.message?.includes("No changes detected")){
                toastAlert.info(data.message);
            } else {
            toastAlert.success("Profile updated successfully!");
            }

            onSuccess?.();
        } catch (error: any) {
           const data = error?.response?.data;

           if (Array.isArray(data?.errors)) {
                toastAlert.error(data.errors.join(", "));
            } else if (typeof data?.error === "string") {
                toastAlert.error(data.error);
            } else if (typeof data?.message === "string") {
                toastAlert.error(data.message);
            } else {
                toastAlert.error(error?.message || "Update failed");
            }
        } finally {
            setIsLoading(false);
        }
    };

    // const updatedAt = user.updated_at ? new Date(user.updated_at) : null;

    return (
        <form className="general-form" onSubmit={handleSubmit}>
            <article className="updated-at-data">
                <p> Last updated at: </p>
                <p> {formData.updatedAt ? new Date(formData.updatedAt).toLocaleDateString() : "-"}</p>
                {/* <p> {formData.updatedAt ? new Date(formData.updatedAt).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", hour12: true }) : "-"}</p> */}
            </article>

            <Input
                type="text"
                name="firstName"
                placeholder="First name"
                value={formData.firstName}
                onChange={handleChange}
            />
            <Input
                type="text"
                name="lastName"
                placeholder="Last name"
                value={formData.lastName}
                onChange={handleChange}
            />
            <Input
                type="email"
                name="email"
                placeholder="Email"
                value={formData.email}
                onChange={handleChange}
            />

            <CountryInput
                value={formData.country}
                onChange={(countryName, code) => {
                    setFormData(prev => ({
                        ...prev,
                        country: countryName || "",
                    }));
                setCountryCode(code.toUpperCase() as CountryCode);
                }}
            />

            <PhoneInput
                name="phoneNumber"
                placeholder="Phone"
                value={formData.phoneNumber}
                onChange={(value) => 
                    setFormData(prev => ({ ...prev, phoneNumber: value || "" }))
                }
                defaultCountry={countryCode}
            />
            
            <SubmitButton type="submit" disabled={isLoading}>
                {isLoading ? "Updating..." : "Save"}
            </SubmitButton>
        </form>
    );
}

export default FormGeneral;