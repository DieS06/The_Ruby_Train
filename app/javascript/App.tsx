import React from "react";
import { Routes, Route, BrowserRouter } from "react-router-dom";
import Home from "./bundles/pages/Home";
import Profile from "./bundles/pages/Profile";

function App() {
  return (
    <BrowserRouter>
        <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/profiles" element={<Profile />} />
            
            {/* <Route path="*" element={<NotFound />} /> */}
        </Routes>
    </BrowserRouter>
  );
}

export default App;