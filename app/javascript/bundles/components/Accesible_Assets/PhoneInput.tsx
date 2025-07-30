import React, { useState } from "react";
import PhoneInput from 'react-phone-number-input';
import type { CountryCode } from 'libphonenumber-js';
import type { PhoneInputProps } from '../../../types/Accesible_Assets/PhoneNumber';
import 'react-phone-number-input/style.css';
import "../../../styles/components/Accesible_Assets/PhoneInput.scss";

function PhoneField({ 
    value, 
    onChange, 
    name, 
    placeholder,
    defaultCountry,
}: PhoneInputProps & {defaultCountry?: CountryCode }) {

    return (
        <PhoneInput
            international
            name={name}
            placeholder={placeholder}
            value={value}
            onChange={onChange}
            defaultCountry={defaultCountry}
        />
    );
}

export { PhoneField as PhoneInput };