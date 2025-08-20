import React from "react";
import Layout from "../layouts/Layout";
import { useAuth } from "@/stores/useAuth";
import AuthCard from "../components/Auth/AuthCard";
import CourseOutline from "../components/Home/CourseOutline";
import ContactForm from "../components/Home/Contact";
import WhatsAppBubble from "../components/Home/Whatsapp";
import About from "../components/Home/About";
import "@/styles/pages/Home.scss";

const Home: React.FC = () => {
  const { user } = useAuth();
  const showAuth = !user;

  return (
    <>  
      <Layout showNav={true} showFooter={true}>
        <section className="home-section">

          {showAuth && (
            <section className="first-sec ">
              <AuthCard />
            </section>
          )}
          <section id="about" className="home-block about">
            <About />
          </section>
          <section id="content_units" className="second-sec">
            <CourseOutline />
          </section>
          <section id="contact" className="home-block contact">
            <ContactForm />
          </section>
          
          <WhatsAppBubble />
        </section>
      </Layout>
    </>
  );
}

export default Home;