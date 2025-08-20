import React from "react";
import { useTranslation } from "react-i18next";
import { GalleryCarousel } from "../Accesible_Assets/Gallery";
import { useAboutSlides } from "./AboutSlides";
import "@/styles/components/Home/About.scss";

const AboutSection: React.FC = () => {
  const { t } = useTranslation("home");
  const slides = useAboutSlides();

  return (
    <section id="about" className="about-section" aria-labelledby="about-title">
      <div className="about-hero">
        <GalleryCarousel
          CarouselItem={{
            items: slides,
            fullscreen: true,
            autoPlay: false,
            intervalMs: 6000,
            ariaLabel: t("about.carousel_aria"),
          }}
        />
      </div>
    </section>
  );
};

export default AboutSection;
