import React, { useState } from 'react';
import { visit } from "@hotwired/turbo";
import { useTranslation } from "react-i18next";
import { Home, User, BookOpen, LogOut, Shield, Users, Pickaxe } from "lucide-react";
import "../../styles/components/SideBar.scss";

import { useAuth } from "../../stores/useAuth";

interface SideBarProps {
    userRole: string[];
    onChange?: (tab: "personal" | "progress") => void;
}

const SideBar: React.FC<SideBarProps> = ({userRole, onChange}) => {
    const { t } = useTranslation("common");
    const [isOpen, setIsOpen] = useState(false);
    const { user, signOut } = useAuth();

    const handleMouseEnter = () => {
        setIsOpen(true);
    };

    const handleMouseLeave = () => {
        setIsOpen(false);
    };

    const handleSignOut = () => {
        signOut();
        visit("/");
    }

    return (
        <aside className={`sidebar 
            ${isOpen ? 'open' : 'collapsed'}`}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
        >

            <div className="sidebar-header">
               
            </div>
            <nav className="sidebar-nav">
                <a href="/" className="sidebar-link first-link">
                    <Home size={18} />
                    <span>Home</span>
                </a>
                <a href="/profiles" className="sidebar-link second-link">
                    <User size={18} />
                    <span>Profile</span>
                </a>
                <a href="/content_units" className="sidebar-link third-link">
                    <BookOpen size={18} />
                    <span>Course</span>
                </a>
                <a href="/profiles" className="sidebar-link fourth-link">
                    <Pickaxe size={18} />
                    <span>Progress</span>
                </a>

                {/*CONDITION RENDERING*/}
                {/* {Array.isArray(userRole) && (
                    <>
                        {( userRole.includes("mentor") || userRole.includes("academy") || userRole.includes("admin") || userRole.includes("super_admin")) && (
                            <a href="/profiles" className="sidebar-link">
                                <Users size={18} />
                                <span>Groups</span>
                            </a>
                        )}
                        {( userRole.includes("admin") || userRole.includes("super_admin")) && (
                            <a href="/profiles" className="sidebar-link">
                                <Shield size={18} />
                                <span>Admin</span>
                            </a>
                        )}
                    </>
                )} */}
                <section className="sidebar-bottom">
                    <button onClick={handleSignOut} className="sidebar-link fifth-link">
                        <LogOut size={18} />
                        <span>{t("navbar.sign-out", {ns: "common"})}</span>
                    </button>
                    {/* <a href="/profiles" className="sidebar-link sixth-link">
                        <Settings size={18} />
                        <span>Settings</span>
                    </a> */}
                </section>
            </nav>
        </aside>      
    );
};

export { SideBar };