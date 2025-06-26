import React from "react";
import "../../styles/layouts/Layout.scss";
import type { Props } from "../../types/Children";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

const Layout = ({ children }: Props) => (
  <>
    <div id="layout-root">
      <Navbar />
      <main>
        {children}
      </main>
      <Footer />
    </div>
  </>
);

export default Layout;