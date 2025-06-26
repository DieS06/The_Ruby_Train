import React, { useEffect } from "react";
import { Routes, Route, BrowserRouter } from "react-router-dom";
import { useAuth } from "./stores/useAuth";
import LanguageSwitcher from "./bundles/components/Locales/LanguageSwitcher";
import { ToastContainer } from "react-toastify";
import Home from "./bundles/pages/Home";
import Profile from "./bundles/pages/Profile";
import ResetPassword from "./bundles/pages/ResetPassword";

function App() {
  
  useEffect(() => {
    const authFromSession = sessionStorage.getItem("auth-temp");

    if (authFromSession) {
      const { user, token } = JSON.parse(authFromSession);
      useAuth.getState().setUser(user, token);
    }
  }, []);

  return (
    <BrowserRouter>
          <LanguageSwitcher/>
          <Routes>
              <Route path="/" element={<Home />}/>
              <Route path="/profiles" element={<Profile />}/>
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
  );
}

export default App;