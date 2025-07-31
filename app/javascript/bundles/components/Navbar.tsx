import React, { useState} from "react";
import { visit } from "@hotwired/turbo";
import { useTranslation } from "react-i18next";
import ToastPreview from "./Utils/ToastPreview";
import "@styles/components/Navbar.scss";

import { useAuth } from "../../stores/useAuth";

const logoUrl = '/icon.svg';

const Navbar: React.FC = () => {
    const { t } = useTranslation("common");
    const { user, signOut } = useAuth();
    const [ authView, setAuthView ] = useState<"signIn" | "signUp">("signIn"); 
    
    const handleAuthToggle = () => {
        const nextView = authView === "signIn" ? "signUp" : "signIn";
        setAuthView(nextView);
        window.dispatchEvent(new CustomEvent("auth-toggle", { detail: nextView }));
    }

    const handleSignOut = () => {
        signOut();
        visit("/");
    }

  return (
    <>
        <header>
            <nav className="nav-bar">
                <ul className="nav-list">
                    <li className="nav-grid">
                        <a href="/" className="nav-logo grid-col-span-2">
                            <img src={logoUrl} alt="Equi-X Logo" className="logo"/>
                        </a>
                        <div className="nav-links grid-col-span-4">
                            <a href="/profiles" className="nav-link">{t("navbar.link-one", {ns: "common"})}</a>
                            <a href="/content_units" className="nav-link">{t("navbar.link-two", {ns: "common"})}</a>
                            <a href="/contact" className="nav-link">{t("navbar.link-three", {ns: "common"})}</a>
                        </div>

                         <div className="nav-switches grid-col-span-2">
                            { user ? (
                                <button className="auth-btn" onClick={handleSignOut}>
                                    {t("navbar.sign-out", {ns: "common"})}
                                </button>
                            ) : (
                                <button className="auth-btn" onClick={handleAuthToggle}>
                                    {t(authView === "signIn" ? "navbar.signUp" : "navbar.signIn")}
                                </button>
                            )}
                            <ToastPreview />
                        </div> 
                            
                    </li>
                </ul>
            </nav>
        </header>
    </>
    );
}

export default Navbar ;