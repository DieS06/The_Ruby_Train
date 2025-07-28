import React, { useState } from 'react';
import { Home, User, BookOpen, LogOut, Settings, Shield, Users } from "lucide-react";
import "../../../styles/components/Profile/SideBar.scss";

interface SideBarProps {
    userRole: string[];
    onChange?: (tab: "personal" | "progress") => void;
}

const SideBar: React.FC<SideBarProps> = ({userRole, onChange}) => {
    const [isOpen, setIsOpen] = useState(false);

    const handleMouseEnter = () => {
        setIsOpen(true);
    };

    const handleMouseLeave = () => {
        setIsOpen(false);
    };

    return (
        <aside className={`profile-sidebar 
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
                <a href="/profiles/me" className="sidebar-link second-link">
                <User size={18} />
                <span>Profile</span>
                </a>
                <a href="/courses" className="sidebar-link third-link">
                <BookOpen size={18} />
                <span>Progress</span>
                </a>

                {/*CONDITION RENDERING*/}
                {( userRole.includes("mentor") || userRole.includes("academy") || userRole.includes("admin") || userRole.includes("super_admin")) && (
                    <a href="/groups" className="sidebar-link">
                        <Users size={18} />
                        <span>Groups</span>
                    </a>
                )}
                {( userRole.includes("admin") || userRole.includes("super_admin")) && (
                    <a href="/admin" className="sidebar-link">
                        <Shield size={18} />
                        <span>Admin</span>
                    </a>
                )}
                {/* {( userRole === "academy" || userRole === "admin" || userRole === "super_admin") && (
                    
                )} */}

                <a href="/users/sign_out" className="sidebar-link fourth-link">
                <LogOut size={18} />
                <span>Sign out</span>
                </a>
                <a href="/config" className="sidebar-link fifth-link">
                <Settings size={18} />
                <span>Settings</span>
                </a>

                
            </nav>
        </aside>      
    );
};

export { SideBar };