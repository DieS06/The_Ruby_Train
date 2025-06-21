import React, {useEffect} from 'react';
import { SideBar } from '../layouts/SideBar';
import { GalleryCarousel } from '../components/Profile/Gallery';
import { getMyProfile } from '../../services/profileService';
import { useNavigate } from 'react-router-dom';
import '../../styles/pages/Profile.scss';
import "../../styles/components/Profile/GlassPanel.scss";
import { GlassFilter } from "../components/Shapes/svgFilter";
import EngineCanvas from '../three.js/Core/Engine';

const Profile: React.FC = () => {
    const [profile, setProfile] = React.useState(null);
    const navigate = useNavigate();

    useEffect(() => {getMyProfile()
        .then(setProfile)
        .catch((err) => {
            console.error(err);
            if (err.message.includes("401") || err.message.includes("Unauthorized")) {
                navigate("/");
            }
        });
    }, []);

    return (
        <>     
            <div className="profile-container">
                <SideBar/>
                <EngineCanvas/>
                <canvas />
                <section className="profile-section">
                    <GlassFilter></GlassFilter>
                    <article className='first-section glass'></article>
                    <article className='second-section'></article>
                    <article className='third-section glass'></article>
                    <article className='fourth-section glass'>
                        <GalleryCarousel/>
                    </article>
                    <article className='fifth-section glass'></article>
                </section>
            </div>
        </>   
    );
}

export default Profile;