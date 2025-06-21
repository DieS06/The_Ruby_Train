import React, { useState } from "react";
import PhoneInput from 'react-phone-number-input';
import type { PhoneInputProps } from '../../../types/PhoneNumber';
import 'react-phone-number-input/style.css';
import "../../../styles/components/Accesible_Assets/PhoneInput.scss";


function PhoneField({ 
    value, 
    onChange, 
    placeholder = "Phone number", 
    name = "phone",
}: PhoneInputProps) {
    const [phone_code, setPhone] = useState("");
    const isOnlyCountryCode = phone_code === "+000";

    return (
        <PhoneInput
            international
            className={isOnlyCountryCode ? "phone--code-only" : "phone--filled"}
            name={name}
            placeholder={placeholder}
            value={value}
            onChange={(value) => setPhone(value || "")}
        />
    );
}

export { PhoneField as PhoneInput };