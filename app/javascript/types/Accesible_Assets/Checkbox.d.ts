type CheckboxProps = {
    name: string;
    label?: string;
    checked: boolean;
    required?: boolean;
    onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
};

export type { CheckboxProps };