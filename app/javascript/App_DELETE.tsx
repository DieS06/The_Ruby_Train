import { useEffect } from "react";
import { useAuth } from "./stores/useAuth";

function App() {
  
  useEffect(() => {
    const authFromSession = sessionStorage.getItem("auth-temp");

    if (authFromSession) {
      const { user, token } = JSON.parse(authFromSession);
      useAuth.getState().setUser(user, token);
    }
  }, []);

  return (
    <>
    
    </>
  );
}

export default App;