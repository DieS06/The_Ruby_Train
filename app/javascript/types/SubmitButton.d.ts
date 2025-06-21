import { AriaButtonProps } from "react-aria";

type SubmitButtonProps = {
  children: React.ReactNode;
  disabled?: boolean;
} & AriaButtonProps<"button"> & React.ButtonHTMLAttributes<HTMLButtonElement>;

export type { SubmitButtonProps };