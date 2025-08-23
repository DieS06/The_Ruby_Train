import React, { useCallback } from 'react';
import { ArrowLeftFromLine } from "lucide-react";
import { visit } from "@hotwired/turbo";
import "../../../styles/components/Accesible_Assets/BackButton.scss";

type BackButtonProps = {
  onClick?: () => void;
  fallbackUrl?: string; // opcional: define a dónde ir si no hay historial / referrer
};

const BackButton: React.FC<BackButtonProps> = ({ onClick, fallbackUrl = "/content_units" }) => {
  const handleClick = useCallback(() => {
    if (onClick) return onClick();

    const { referrer, location } = document;
    const hasHistory = window.history.length > 1;
    const sameOrigin = referrer && new URL(referrer).origin === location.origin;

    if (hasHistory && sameOrigin) {
      window.history.back();
    } else {
      visit(fallbackUrl); // Turbo navegación como respaldo
    }
  }, [onClick, fallbackUrl]);

  return (
    <button className="back-button" type="button" onClick={handleClick} aria-label="Back Button">
      <ArrowLeftFromLine />
    </button>
  );
};

export default BackButton;