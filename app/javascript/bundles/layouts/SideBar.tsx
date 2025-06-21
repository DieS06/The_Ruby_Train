import React, { useState } from 'react';
import { NavLink } from "react-router-dom";
import { Home, User, BookOpen, Settings, Pin, PinOff } from "lucide-react";
import Logo from "../../assets/logo.svg";
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
                <span>Inicio</span>
                </NavLink>
                <NavLink to="/profiles/me" className="sidebar-link second-link">
                <User size={18} />
                <span>Perfil</span>
                </NavLink>
                <NavLink to="/courses" className="sidebar-link third-link">
                <BookOpen size={18} />
                <span>Cursos</span>
                </NavLink>
                <NavLink to="/config" className="sidebar-link fourth-link">
                <Settings size={18} />
                <span>Configuración</span>
                </NavLink>
            </nav>
        </aside>      
    );
};

export { SideBar };