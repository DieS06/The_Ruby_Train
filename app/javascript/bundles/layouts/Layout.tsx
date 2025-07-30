import React from "react";
import { ApolloProvider } from "@apollo/client";
import apolloClient from "@/apollo/client";
import LanguageSwitcher from "../components/Locales/LanguageSwitcher";
import { ToastContainer } from "react-toastify";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
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
        <LanguageSwitcher/>

          <div id="layout-root">
            {showNav && <Navbar />}

              <main>
                <ConfirmationDialog />
                {children}
              </main>

            {showFooter && <Footer />}
          </div>

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
        </ApolloProvider>
    </>
  );
} 

export default Layout;