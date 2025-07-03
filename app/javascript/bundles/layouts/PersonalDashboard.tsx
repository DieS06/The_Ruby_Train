import React from 'react';
import { GalleryCarousel } from '../components/Profiles/Gallery';
import { PersonalInformation } from '../components/Profiles/Personal_Information/PersonalInfo';
import { GlassFilter } from "../components/Shapes/svgFilter";
import type { UserProfile } from '../../types/Profile/UserInformation';
import '../../styles/components/Profile/Dashboard.scss';
import "../../styles/components/Profile/GlassPanel.scss";

interface ProfileProps {
    profile: UserProfile;
}

const Personal: React.FC<ProfileProps> = ({profile}) => {
    
    if(!profile) {
        return <div className="loading-screen">
            Loading...
        </div>;
    }

    return (
        <>   
            <div className="dashboard-container">
                
                <section className="dashboard-section">
                    <GlassFilter/>
                    <article className='first-section glass'>
                        <PersonalInformation/>
                    </article>
                    <article className='second-section '>
                        
                    </article>
                    <article className='third-section glass'>
                        <GalleryCarousel/>
                    </article>
                </section>
            </div>
           
        </>   
    );
}

export default Personal;