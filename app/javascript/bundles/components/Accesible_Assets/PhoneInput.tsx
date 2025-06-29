import React, { useState } from "react";
import PhoneInput from 'react-phone-number-input';
import type { PhoneInputProps } from '../../../types/Accesible_Assets/PhoneNumber';
import 'react-phone-number-input/style.css';
import "../../../styles/components/Accesible_Assets/PhoneInput.scss";

function PhoneField({ 
    value, 
    onChange, 
    placeholder = "Phone number", 
    name = "phone",
}: PhoneInputProps) {
    
    return (
        <PhoneInput
            international
            name={name}
            placeholder={placeholder}
            value={value}
            onChange={onChange}
        />
    );
}

export { PhoneField as PhoneInput };