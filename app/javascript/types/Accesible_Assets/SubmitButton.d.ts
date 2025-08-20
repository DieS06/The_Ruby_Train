import { AriaButtonProps } from "react-aria";

type SubmitButtonProps = {
  children: React.ReactNode;
  isLogicallyDisabled?: boolean;
  onPress?: () => void;
} & AriaButtonProps<"button"> & React.ButtonHTMLAttributes<HTMLButtonElement>;

export type { SubmitButtonProps };