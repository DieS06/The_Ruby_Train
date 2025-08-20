type InputProps = {
  id?: string;
  placeholder?: string;
  label?: string;
  name: string;
  type?: string;
  value: string | undefined;
  required?: boolean;
  ariaLabel?: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
};

export type { InputProps };