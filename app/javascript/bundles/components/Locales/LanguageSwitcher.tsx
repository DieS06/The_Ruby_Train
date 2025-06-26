import i18n from "../../../i18n"
import { useTranslation } from "react-i18next"
import "../../../styles/locales/LanguageSwitcher.scss"

export default function LanguageSwitcher() {
  const { t } = useTranslation()

  const toggleLanguage = () => {
    const nextLang = i18n.language === "es" ? "en" : "es"
    i18n.changeLanguage(nextLang)
  }

  const label = i18n.language === "es" ? t("EN") : t("ES")

  return (
    <button onClick={toggleLanguage} className="language-switcher">
      {label}
    </button>
  )
}
