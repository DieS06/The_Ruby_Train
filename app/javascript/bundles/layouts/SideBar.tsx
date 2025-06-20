import React from 'react';
import { NavLink } from "react-router-dom";
import { Home, User, BookOpen, Settings, Pin } from "lucide-react";
import "../../styles/layouts/SideBar.scss";

const SideBar: React.FC = () => {
    return (
        <aside className='profile-sidebar'>
            <div className="sidebar-pin">
                <Pin/>
            </div>

            <div className="sidebar-header">
                <img src="/icon.svg" alt="Logo" className="sidebar-logo" />
            </div>

            <nav className="sidebar-nav">
                <NavLink to="/" className="sidebar-link">
                <Home size={18} />
                <span>Inicio</span>
                </NavLink>
                <NavLink to="/profiles/me" className="sidebar-link">
                <User size={18} />
                <span>Perfil</span>
                </NavLink>
                <NavLink to="/courses" className="sidebar-link">
                <BookOpen size={18} />
                <span>Cursos</span>
                </NavLink>
                <NavLink to="/config" className="sidebar-link">
                <Settings size={18} />
                <span>Configuración</span>
                </NavLink>
            </nav>
        </aside>      
    );
};

export { SideBar };