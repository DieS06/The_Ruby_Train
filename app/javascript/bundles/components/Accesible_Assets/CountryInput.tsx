import { ComboBox, Input, Popover, ListBox, ListBoxItem } from "react-aria-components";
import type { CountryProps } from "../../../types/Country.type";
import countries from "i18n-iso-countries";
import en from "i18n-iso-countries/langs/en.json";
import "../../../styles/components/Accesible_Assets/CountryInput.scss";

countries.registerLocale(en);

const countryList = Object.entries(countries.getNames("en", { select: "official" }))
  .filter(([code]) => typeof code === "string" && code.length === 2)
  .map(([code, name]) => ({ code, name }));

export function CountrySelectField({value, onChange }: CountryProps) {
  return (
    <ComboBox selectedKey={value} onSelectionChange={(key) => {
        if (typeof key === "string") onChange(String(key));}}
        aria-label="Select a country…">
      <Input placeholder="Select a country…" />
      <Popover>
        <ListBox>
          {countryList.map(({ code, name }) => (
            <ListBoxItem key={code}>{name}</ListBoxItem>
          ))}
        </ListBox>
      </Popover>
    </ComboBox>
  );
}

export { CountrySelectField as CountryInput };