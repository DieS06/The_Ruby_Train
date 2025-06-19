import React from "react"; 
import "../../styles/components/Navbar.scss";

const logoUrl = '/icon.svg';

const Navbar: React.FC = () => {
  return (
    <>
        <header>
            <nav className="nav-bar">
                <ul className="nav-list">
                    <li className="nav-grid">
                        <a className="nav-logo grid-col-span-2" href="/">
                            <img src={logoUrl} alt="Equi-X Logo" className="logo"/>
                        </a>
                        <div className="nav-links grid-col-span-4">
                            <a className="nav-link" href="/">About</a>
                            <a className="nav-link" href="/">Courses</a>
                            <a className="nav-link" href="/">Contact</a>
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