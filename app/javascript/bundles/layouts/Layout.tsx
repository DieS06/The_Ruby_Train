import React from "react";
import { ApolloProvider } from "@apollo/client";
import apolloClient from "@/apollo/client";
import LanguageSwitcher from "../components/Locales/LanguageSwitcher";
import Navbar from "../components/Home/Navbar";
import Footer from "../components/Home/Footer";
import ConfirmationDialog from "../components/Utils/ConfirmationDialog";
import "../../styles/layouts/Layout.scss";

interface LayoutProps extends React.PropsWithChildren {
  showNav?: boolean;
  showFooter?: boolean;
}

const Layout: React.FC<LayoutProps> = ({ 
  children,
  showNav = true,
  showFooter = true,
}) => {
  return(
    <>
      <ApolloProvider client={apolloClient}>
        <div id="top" aria-hidden="true" />
        <LanguageSwitcher/>

          <div id="layout-root">
            {showNav && <Navbar />}

              <main>
                <ConfirmationDialog />
                {children}
              </main>

            {showFooter && <Footer />}
          </div>
        </ApolloProvider>
    </>
  );
} 

export default Layout;