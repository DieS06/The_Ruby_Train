import { Country } from "react-phone-number-input";

type CountryProps = {
  value: Country | string;
  onChange: (value: string) => void;

};

export type { CountryProps };