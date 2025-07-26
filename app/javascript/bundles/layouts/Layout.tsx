import React from "react";
import { ApolloProvider } from "@apollo/client";
import apolloClient from "@/apollo/client";

import "../../styles/layouts/Layout.scss";
import type { Props } from "../../types/Children";
import LanguageSwitcher from "../components/Locales/LanguageSwitcher";
import { ToastContainer } from "react-toastify";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

const Layout = ({ children }: Props) => (
  <>
    <LanguageSwitcher/>
    <ApolloProvider client={apolloClient}>
      <div id="layout-root">
        <Navbar />
        <main>
          {children}
        </main>
        <Footer />
      </div>
    </ApolloProvider>
    <ToastContainer
              autoClose={false}
              closeOnClick={true}
              closeButton={true}
              pauseOnHover={true}
              draggable={true}
              theme="colored"
              className={"toast-container"}
              progressClassName={"toast-progress"}
              hideProgressBar={false}
              newestOnTop={false}        
      />
  </>
);

export default Layout;