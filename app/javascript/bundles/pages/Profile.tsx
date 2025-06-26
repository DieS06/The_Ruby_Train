import React, { use, useEffect, useState } from 'react';
import { SideBar } from '../layouts/SideBar';
import { GalleryCarousel } from '../components/Profile/Gallery';
import { AchievementPanel } from '../components/Profile/AchievementPanel';
import { PersonalInformation } from '../components/Profile/PersonalInfo';
import { Badges } from '../components/Profile/Badges';
import { ToastContainer } from "react-toastify";
import '../../styles/pages/Profile.scss';
import "../../styles/components/Profile/GlassPanel.scss";
import { GlassFilter } from "../components/Shapes/svgFilter";

import useAuthGuard from '../../stores/useAuthGuard';


const Profile: React.FC = () => {
    const [profile, setProfile] = useState(null);

    useAuthGuard(setProfile);

    if(!profile) return <div></div>;
 
    return (
        <>   
            <div className="profile-container">
                <SideBar/>
                <section className="profile-section">
                    <GlassFilter/>
                    <article className='first-section glass'>
                        <Badges/>
                    </article>
                    <article className='second-section'></article>
                    <article className='third-section glass'>
                        <PersonalInformation/>
                    </article>
                    <article className='fourth-section glass'>
                        <GalleryCarousel/>
                    </article>
                    <article className='fifth-section glass'>
                        <AchievementPanel/>
                    </article>
                </section>
            </div>
            <ToastContainer
                position="top-right"
                autoClose={4000}
                hideProgressBar={false}
                newestOnTop={false}
                closeOnClick
                pauseOnFocusLoss
                draggable
                pauseOnHover
                theme="colored"
            />
        </>   
    );
}

export default Profile;