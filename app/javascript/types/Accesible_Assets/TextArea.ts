export type TextAreaProps = {
  id?: string;
  label?: string;
  placeholder?: string;
  ariaLabel?: string;
  name: string;
  value: string;
  required?: boolean;
  maxLength?: number;
  showCount?: boolean;
  rows?: number;
  onChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void;
};