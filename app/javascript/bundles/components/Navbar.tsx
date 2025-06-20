import React from "react";
import { Link } from "react-router-dom";
import "../../styles/components/Navbar.scss";

const logoUrl = '/icon.svg';

const Navbar: React.FC = () => {

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
                            <Link className="nav-link" to="/profiles">Test Profile</Link>
                            <Link className="nav-link" to="/">Courses</Link>
                            <Link className="nav-link" to="/">Contact</Link>
                        </div>
                        <div className="nav-search grid-col-span-2">
                            <svg  className="search-ico" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" strokeWidth="2"/>
                                <line x1="16.5" y1="16.5" x2="22" y2="22" stroke="currentColor" strokeWidth="2"/>
                            </svg>

                            <input 
                                type= "search"
                                aria-label="Search"
                                placeholder="Search..."
                                className="search-input"
                            />
                        </div>
                            
                    </li>
                </ul>
            </nav>
        </header>
    </>
    );
}

export default Navbar ;