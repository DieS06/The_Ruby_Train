import React, { useState } from "react";
import { toastAlert } from "../../Utils/toasts";
import api from "@/services/Axios/axios";
import { Input } from "../../Accesible_Assets/Input";
import { PhoneInput } from "../../Accesible_Assets/PhoneInput";
import { CountryInput } from "../../Accesible_Assets/CountryInput";
import type { CountryCode } from 'libphonenumber-js';
import { SubmitButton } from "../../Accesible_Assets/SubmitButton";
import "@/styles/components/Profile/Forms/FormGeneral.scss";

interface Props {
  user: {
    first_name: string;
    last_name: string;
    email: string;
    phone_number: string;
    country: string;
  };
  onSuccess?: () => void;
}

const FormGeneral: React.FC<Props> = ({ user, onSuccess }) => {
    const [countryCode, setCountryCode] = useState<CountryCode | undefined>(undefined);
    const [formData, setFormData] = useState({
        ...user,
        firstName: user.first_name || "",
        lastName: user.last_name || "",
        email: user.email || "",
        phoneNumber: user.phone_number || "",
        country: user.country || ""
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
            await api.put("/users/update_info", {
                user: {
                    first_name: formData.firstName,
                    last_name: formData.lastName,
                    email: formData.email,
                    phone_number: formData.phoneNumber,
                    country: formData.country
                    }
                },
                {
                    headers: {
                        Accept: "application/json",
                    }
                }
            );

            toastAlert.success("Profile updated successfully!");
            onSuccess?.();
        } catch (error: any) {
            if (error.response?.data?.errors){
                toastAlert.error(error.response.data.errors.join(", "));
            }else {
                toastAlert.error(error);
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <form className="general-form" onSubmit={handleSubmit}>
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