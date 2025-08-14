import i18n from "i18next"
import { initReactI18next } from "react-i18next"
import LanguageDetector from "i18next-browser-languagedetector"

import en from "./locales/en/en.json"
import es from "./locales/es/es.json"
import enRegister from "./locales/en/users_mod/signUp.json"
import esRegister from "./locales/es/users_mod/signUp.json"
import enLogin from "./locales/en/users_mod/signIn.json"
import esLogin from "./locales/es/users_mod/signIn.json"
import enResetPassword from "./locales/en/users_mod/reset_pass.json"
import esResetPassword from "./locales/es/users_mod/reset_pass.json"
import esHome from "./locales/es/home_es.json"
import enHome from "./locales/en/home_en.json"

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'],
    },
    resources: {
      en: { 
        register: enRegister,
        login: enLogin,
        reset: enResetPassword,
        home: enHome,

        common: en
      },
      es: { 
        register: esRegister,
        login: esLogin,
        reset: esResetPassword,
        home: esHome,

        common: es
      }
    },
    fallbackLng: "es",
    ns: ["auth"],
    defaultNS: "common",
    supportedLngs: ["en", "es"],
    interpolation: {
      escapeValue: false
    }
  })

export default i18n