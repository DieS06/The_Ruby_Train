import React from "react";

import "../../../styles/components/Search/SearchBar.scss";

function SearchBar() {

    return(
        <div className="search-bar">
            <svg  className="search-ico" viewBox="0 0 24 24" aria-hidden="true">
                <circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" strokeWidth="2"/>
                <line x1="16.5" y1="16.5" x2="22" y2="22" stroke="currentColor" strokeWidth="2"/>
            </svg>

            <input  
                aria-label="Search"
                placeholder="Search..."
                className="search-input"
            />
        </div>
    )
}

export { SearchBar };