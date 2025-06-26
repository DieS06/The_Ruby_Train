import { Country } from 'react-phone-number-input';

type PhoneInputProps = {
    value: string | undefined;
    onChange: (value: string | undefined) => void;
    placeholder?: string;
    name?: string;
    defaultCountry?: Country;
};

export type { PhoneInputProps };