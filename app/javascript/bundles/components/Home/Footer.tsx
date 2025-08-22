import React, { useEffect, useState } from "react";
import "@/styles/components/Home/Footer.scss";
import { ArrowUp } from "lucide-react";

function getAppVersion(): string {
  const meta = document.querySelector('meta[name="app-version"]') as HTMLMetaElement | null;
   return meta?.content ||  "dev";
}

const appVersion = getAppVersion();

const Footer: React.FC = () => {
  const year = new Date().getFullYear();

  return (
    <footer className="site-footer" role="contentinfo" aria-label="Site footer">
      <span id="top" aria-hidden="true" style={{position:'absolute',top:0}} />
      
      <div className="footer-inner">
        <div className="footer-grid">

          <nav className="footer-col" aria-label="Quick links">
            <h5 className="col-title">Explore</h5>
            <ul className="col-list">
              <li><a href="/">Home</a></li>
              <li><a href="/about">About</a></li>
              <li><a href="/contact">Contact</a></li>
              <li><a href="/course">The Ruby Train</a></li>
            </ul>
          </nav>

          <section className="footer-col">

            <h5 className="col-title">Support</h5>
            <ul className="col-list">
              <li><a href="mailto:support@therubytrain.com">support@therubytrain.com</a></li>
              <li><a href="/help">Help Center</a></li>
              <li><a href="/terms">Terms</a></li>
              <li><a href="/privacy">Privacy</a></li>
            </ul>
          </section>

          <section className="footer-col">
            <h5 className="col-title">Social Media</h5> 
            <div className="socials" aria-label="Social media">
              <a href="https://github.com/tu-org" target="_blank" rel="noopener noreferrer" aria-label="GitHub" title="GitHub">
                <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M12 .5a12 12 0 0 0-3.79 23.4c.6.1.82-.26.82-.58v-2.1c-3.34.73-4.04-1.6-4.04-1.6-.55-1.4-1.33-1.77-1.33-1.77-1.08-.74.08-.73.08-.73 1.2.09 1.83 1.23 1.83 1.23 1.07 1.83 2.82 1.3 3.51.99.11-.78.42-1.3.76-1.6-2.66-.3-5.46-1.33-5.46-5.91 0-1.31.47-2.38 1.24-3.22-.12-.3-.54-1.52.12-3.17 0 0 1-.32 3.3 1.23a11.4 11.4 0 0 1 6 0c2.3-1.55 3.3-1.23 3.3-1.23.66 1.65.24 2.87.12 3.17.77.84 1.24 1.9 1.24 3.22 0 4.6-2.8 5.6-5.47 5.9.43.37.81 1.1.81 2.22v3.29c0 .32.21.69.82.57A12 12 0 0 0 12 .5Z"/></svg>
              </a>
              <a href="https://www.linkedin.com/company/tu-org" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn" title="LinkedIn">
                <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M4.98 3.5A2.5 2.5 0 1 1 0 3.5a2.5 2.5 0 0 1 4.98 0ZM.5 8.5h4.9V24H.5zM9 8.5h4.7v2.1h.07c.65-1.2 2.26-2.46 4.66-2.46C22.6 8.14 24 10.4 24 14v10h-4.9v-9c0-2.15-.77-3.62-2.7-3.62-1.47 0-2.34 1-2.72 1.97-.14.33-.18.79-.18 1.25V24H8.6s.06-14.87 0-16.4H9Z"/></svg>
              </a>
              <a href="https://x.com/tu-org" target="_blank" rel="noopener noreferrer" aria-label="X" title="X / Twitter">
                <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M18.24 2H21l-6.55 7.48L22 22h-6.78l-5.3-7.06L3.8 22H1.04l7.12-8.13L2 2h6.86l4.83 6.53L18.24 2Zm-1.18 18h1.78L7.04 4H5.18l11.88 16Z"/></svg>
              </a>
            </div>
          </section>
        </div>

        <div className="footer-bottom">
          <small>
            © {year} The Ruby Train -
            <span className="version"> {appVersion}</span>
          </small>
        </div>
      </div>
    </footer>
  );
};

export default Footer;

