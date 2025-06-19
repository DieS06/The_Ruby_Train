import React from "react";
import "../../styles/pages/Home.scss";
import Layout from "../components/Layout";
import AuthCard from "../components/Auth/AuthCard";

const Home: React.FC = () => {

  return (
    <>  
      <Layout>
        <section className="home-section">
          <section className="first-sec ">
            <AuthCard />
          </section>
          <section className="second-sec">
          </section>
        </section>
      </Layout>
    </>
  );
}

export default Home;