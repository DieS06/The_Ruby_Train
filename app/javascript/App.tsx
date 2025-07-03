import React, { useEffect } from "react";
import { Routes, Route, BrowserRouter } from "react-router-dom";
import { ApolloProvider } from '@apollo/client';
import apolloClient from './apollo/client';
import { useAuth } from "./stores/useAuth";
import LanguageSwitcher from "./bundles/components/Locales/LanguageSwitcher";
import Home from "./bundles/pages/Home";
import Profile from "./bundles/pages/Profile";
import ResetPassword from "./bundles/pages/ResetPassword";
import { ToastContainer } from "react-toastify";

function App() {
  
  useEffect(() => {
    const authFromSession = sessionStorage.getItem("auth-temp");

    if (authFromSession) {
      const { user, token } = JSON.parse(authFromSession);
      useAuth.getState().setUser(user, token);
    }
  }, []);

  return (
    <ApolloProvider client={apolloClient}>
      <BrowserRouter>
            <LanguageSwitcher/>
            <Routes>
                <Route path="/" element={<Home />}/>
                <Route path="/*" element={<Profile />}/>
                <Route path="/reset-password" element={<ResetPassword />}/>
                {/* <Route path="*" element={<NotFound />} /> */}
            </Routes>
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
      </BrowserRouter>
    </ApolloProvider>
  );
}

export default App;