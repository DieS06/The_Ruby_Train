import React from "react";
import { BrowserRouter } from "react-router-dom";
import "../../styles/layouts/Layout.scss";
import Navbar from "./Navbar";
import Footer from "./Footer";

type Props = {
  children: React.ReactNode;
};

const Layout = ({ children }: Props) => (
  <BrowserRouter>
    <div id="layout-root">
      <Navbar />
      <main>{children}</main>
      <Footer />
    </div>
  </BrowserRouter>
);

export default Layout;
