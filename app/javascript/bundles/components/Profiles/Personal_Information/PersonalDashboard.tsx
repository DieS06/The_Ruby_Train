import React, { useMemo } from 'react';
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

    const profileSlides = useMemo(() => [
        { id: 1, content: <div>Welcome to The Ruby Train</div> },
        { id: 2, content: <div>Progress updated</div> },
        { id: 3, content: <div>New course available</div> },
    ], []);

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
                        <GalleryCarousel 
                            CarouselItem={{
                                items: profileSlides,
                                autoPlay: true,
                                intervalMs: 8000,
                                ariaLabel: "Profile carousel",
                            }}
                        />
                    </article>
                </section>
            </div>
           
        </>   
    );
}

export default Personal;