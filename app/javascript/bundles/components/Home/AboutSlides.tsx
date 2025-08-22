import React from "react";
import { useTranslation } from "react-i18next";

export function useAboutSlides(): { id: string; content: React.ReactNode }[] {
  const { t } = useTranslation("home");

  return [
    {
      id: "intro",
      content: (
        <div className="slide full">
          <h2>{t("about.slider.intro.title")}</h2>
          <p>{t("about.slider.intro.text")}</p>
        </div>
      ),
    },
    // {
    //   id: "mission",
    //   content: (
    //     <div className="slide full">
    //       <h2>{t("about.slider.mission.title")}</h2>
    //       <p>{t("about.slider.mission.text")}</p>
    //     </div>
    //   ),
    // },
    {
      id: "how",
      content: (
        <div className="slide full">
          <h2>{t("about.slider.how.title")}</h2>
          <ul className="slide-list">
            <li>{t("about.features.guided")}</li>
            <li>{t("about.features.evaluations")}</li>
            {/* <li>{t("about.features.projects")}</li>
            <li>{t("about.features.community")}</li> */}
            <li>{t("about.features.cert_path")}</li>
          </ul>
        </div>
      ),
    },
  ];
}
