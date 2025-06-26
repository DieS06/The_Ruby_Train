import React, { useState, useEffect, useRef } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import "../../styles/components/Navbar.scss";
import { useTranslation } from "react-i18next";
import ToastPreview from "./Utils/ToastPreview";
import { useAuth } from "../../stores/useAuth";

const logoUrl = '/icon.svg';

const Navbar: React.FC = () => {
    const { t } = useTranslation("common");
    const { user, signOut } = useAuth();
    const location = useLocation();
    const navigate = useNavigate();

    const [ authView, setAuthView ] = useState<"signIn" | "signUp">("signIn"); 
    
    const isHome = location.pathname === "/";

    const handleAuthToggle = () => {
        const nextView = authView === "signIn" ? "signUp" : "signIn";
        setAuthView(nextView);
        window.dispatchEvent(new CustomEvent("auth-toggle", { detail: nextView }));
    }

    const handleSignOut = () => {
        signOut();
        navigate("/");
    }

  return (
    <>
        <header>
            <nav className="nav-bar">
                <ul className="nav-list">
                    <li className="nav-grid">
                        <Link className="nav-logo grid-col-span-2" to="/">
                            <img src={logoUrl} alt="Equi-X Logo" className="logo"/>
                        </Link>
                        <div className="nav-links grid-col-span-4">
                            <Link className="nav-link" to="/profiles">{t("navbar.link-one", {ns: "common"})}</Link>
                            <Link className="nav-link" to="/course">{t("navbar.link-two", {ns: "common"})}</Link>
                            <Link className="nav-link" to="/contact">{t("navbar.link-three", {ns: "common"})}</Link>
                        </div>

                         <div className="nav-switches grid-col-span-2">
                            {isHome && (
                                user ? (
                                    <button className="auth-btn" onClick={handleSignOut}>
                                        {t("navbar.sign-out", {ns: "common"})}
                                    </button>
                                ) : (
                                   <button className="auth-btn" onClick={handleAuthToggle}>
                                         {t(authView === "signIn" ? "navbar.signUp" : "navbar.signIn")}
                                    </button>
                                )
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