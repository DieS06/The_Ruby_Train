import React, { useState } from 'react';
import { NavLink } from "react-router-dom";
import { Home, User, BookOpen, LogOut, Settings, Pin, PinOff } from "lucide-react";
import Logo  from "../../assets/svgs/logo.inline.svg";
import "../../styles/layouts/SideBar.scss";

const SideBar: React.FC = () => {
    const [isPinned, setIsPinned] = useState(false);
    const [isOpen, setIsOpen] = useState(false);

    const handleMouseEnter = () => {
        if (!isPinned) setIsOpen(true);
    };

    const handleMouseLeave = () => {
        if (!isPinned) setIsOpen(false);
    };

    const togglePin = () => {
        setIsPinned(prev => !prev);
        if (isPinned) setIsOpen(true);
    }

    return (
        <aside className={`profile-sidebar 
            ${isOpen ? 'open' : 'collapsed'}
            ${isPinned ? 'pinned' : ''}`}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
        >

            <div className="sidebar-header" onClick={togglePin}>
                {isPinned ? <PinOff size={23} className="pin" /> : <Pin size={23} className="pin" /> }
                <Logo className="logo" />   
            </div>

            <nav className="sidebar-nav">
                <NavLink to="/" className="sidebar-link first-link">
                <Home size={18} />
                <span>Home</span>
                </NavLink>
                <NavLink to="/profiles/me" className="sidebar-link second-link">
                <User size={18} />
                <span>Profile</span>
                </NavLink>
                <NavLink to="/courses" className="sidebar-link third-link">
                <BookOpen size={18} />
                <span>Course</span>
                </NavLink>
                <NavLink to="/users/sign_out" className="sidebar-link fourth-link">
                <LogOut size={18} />
                <span>Sign out</span>
                </NavLink>
                <NavLink to="/config" className="sidebar-link fifth-link">
                <Settings size={18} />
                <span>Settings</span>
                </NavLink>
            </nav>
        </aside>      
    );
};

export { SideBar };