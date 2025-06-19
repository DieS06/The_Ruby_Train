import React from "react";
import "../../../styles/components/Accesible_Assets/Omniauth.scss";

function Omniauth( { text = "" }: { text?: string }) {
    return (
        <div className="alternative">
            <div className="line-left" />
            <span className="or-text">{text}</span>
            <div className="line-right" />
            <div className="google-login-container">
                <a className="google-login-button" href="/auth/google">
                    {/* <img src={} alt="" /> */}
                </a>
            </div>
            
        </div>  
    );
}

export { Omniauth };