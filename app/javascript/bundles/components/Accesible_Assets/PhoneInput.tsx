import React, { useState } from "react";
import PhoneInput, { getCountries, parsePhoneNumber } from 'react-phone-number-input';
import type { CountryCode } from 'libphonenumber-js';
import type { PhoneInputProps } from '../../../types/Accesible_Assets/PhoneNumber';
import 'react-phone-number-input/style.css';
import "../../../styles/components/Accesible_Assets/PhoneInput.scss";

const ALLOWED_CA_CODES: CountryCode[] = ["BZ","CR","GT","HN","NI","PA","SV"];

function PhoneField({ 
    value, 
    onChange, 
    name, 
    placeholder,
    defaultCountry,
}: PhoneInputProps) {

    return (
        <PhoneInput
            international
            name={name}
            countries={ALLOWED_CA_CODES}
            placeholder={placeholder}
            value={value}
            onChange={onChange}
            defaultCountry={defaultCountry}
        />
    );
}

export { PhoneField as PhoneInput };