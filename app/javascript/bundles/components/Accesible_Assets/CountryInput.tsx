import React, { useMemo, useEffect, useState } from "react";
import { ComboBox, Input, Popover, ListBox, ListBoxItem } from "react-aria-components";
import countries from "i18n-iso-countries";
import type { Key } from "react-aria-components";
import en from "i18n-iso-countries/langs/en.json";
import es from "i18n-iso-countries/langs/es.json";
import { useTranslation } from "react-i18next";
import "../../../styles/components/Accesible_Assets/CountryInput.scss";

countries.registerLocale(en);
countries.registerLocale(es);

export function CountrySelectField({value, onChange }: 
  { value: string; onChange: (countryName: string, countryCode: string) => void }) {
  const { i18n, t } = useTranslation("register");
  const lang = i18n.language.startsWith("es") ? "es" : "en";
  
  const ALLOWED_CA_CODES = ["BZ","CR","GT","HN","NI","PA","SV"];

  const countryList = useMemo(() => {
    return Object.entries(
      countries.getNames(lang, { select: "official" }))
      .filter(([code]) => ALLOWED_CA_CODES.includes(code.toUpperCase()))
      .map(([code, name]) => ({ code: code.toUpperCase(), name }));
  }, [lang]);

  const [inputValue, setInputValue] = useState(value || "");

  useEffect(() => {
    if (value && value !== inputValue) {
      setInputValue(value);
    }
  }, [value]);

  const handleSelection = (key: Key | null) => {
    if (!key || typeof key !== "string") return;
    const select = countryList.find(c => c.code === key);
    if (select) {
      setInputValue(select.name);
      onChange(select.name, select.code);
    }
  };

  return (
    <ComboBox 
      inputValue={inputValue}
      onInputChange={setInputValue}
      onSelectionChange={handleSelection}
      aria-label={t("country.select")}
      allowsCustomValue
      >
      <Input placeholder={t("country.select")} />
      <Popover>
        <ListBox>
          {countryList.map(({ code, name }) => (
            <ListBoxItem key={code} id={code}>
              {name}
            </ListBoxItem>
          ))}
        </ListBox>
      </Popover>
    </ComboBox>
  );
}

export { CountrySelectField as CountryInput };