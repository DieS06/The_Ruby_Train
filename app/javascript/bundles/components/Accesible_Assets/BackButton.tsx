import React from 'react';
import { ArrowLeftFromLine, Pencil } from "lucide-react";
import "../../../styles/components/Accesible_Assets/BackButton.scss";

type BackButtonProps = {
    onClick?: () => void;
};

const BackButton: React.FC<BackButtonProps> = ({ onClick }) => (
    <button className="back-button" type="button" onClick={onClick} aria-label="Back Button">
        <ArrowLeftFromLine />
    </button>
);

export default BackButton;