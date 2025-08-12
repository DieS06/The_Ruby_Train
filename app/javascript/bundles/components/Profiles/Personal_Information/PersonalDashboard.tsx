import React from 'react';
import { GalleryCarousel } from '../../Accesible_Assets/Gallery';
import { PersonalInformation } from './PersonalInfo';
import { GlassFilter } from "../../Shapes/svgFilter";
import type { UserProfile } from '../../../../types/Profile/UserInformation';
import Spinner from '../../Loading/Spinner';
import '../../../../styles/components/Profile/Personal.scss';
import "../../../../styles/components/Profile/GlassPanel.scss";

interface ProfileProps {
    profile: UserProfile;
}

const Personal: React.FC<ProfileProps> = ({profile}) => {

    if(!profile) { return <Spinner />; }

    return (
        <>   
            <div className="dashboard-container">
                
                <section className="dashboard-section">
                    <GlassFilter/>
                    <article className='first-section glass'>
                        <PersonalInformation profileData={profile} />
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