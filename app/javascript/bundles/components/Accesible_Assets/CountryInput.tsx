import { ComboBox, Input, Popover, ListBox, ListBoxItem } from "react-aria-components";
import type { CountryProps } from "../../../types/Accesible_Assets/Country";
import countries from "i18n-iso-countries";
import en from "i18n-iso-countries/langs/en.json";
import es from "i18n-iso-countries/langs/es.json";
import "../../../styles/components/Accesible_Assets/CountryInput.scss";
import { useTranslation } from "react-i18next";

countries.registerLocale(en);
countries.registerLocale(es);

export function CountrySelectField({value, onChange }: CountryProps) {
  const { i18n, t } = useTranslation("register");
  const lang = i18n.language.startsWith("es") ? "es" : "en";

  const countryList = Object.entries(
    countries.getNames(lang, { select: "official" })
  )
    .filter(([code]) => typeof code === "string" && code.length === 2)
    .map(([code, name]) => ({ code, name }));

  return (
    <ComboBox selectedKey={value} onSelectionChange={(key) => {
        if (typeof key === "string") onChange(String(key));}}
        aria-label={t("country.select")}>
      <Input placeholder={t("country.select")} />
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