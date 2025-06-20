import React, {useEffect} from 'react';
import Dashboard from '../layouts/Dashboard';
import { getMyProfile } from '../../services/profileService';
import { useNavigate } from 'react-router-dom';
import '../../styles/pages/Profile.scss';

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
                <Dashboard>
                    <section>
                        
                    </section>
                </Dashboard>
            </div>
        </>   
    );
}

export default Profile;