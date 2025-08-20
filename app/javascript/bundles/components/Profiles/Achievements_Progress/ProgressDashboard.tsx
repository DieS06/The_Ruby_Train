import React from 'react';
import { AchievementPanel } from './AchievementPanel';
import { Badges } from './Badges';
import '../../../../styles/components/Profile/Achievement_Progress/ProgressDashboard.scss';
import "../../../../styles/components/Profile/GlassPanel.scss";

interface ProgressProps {
    progress: any;
}

const Progress: React.FC<ProgressProps> = ({progress}) => {
    
    if(!progress) {
        return <div className="loading-screen">
            Loading...
        </div>;
    }

    return (
        <>   
            <div className="dashboard-container">
                
                <section className="dashboard-section">

                    <article className='first-section'>

                    </article>
                    <article className='second-section glass'>
                        <Badges/>
                    </article>
                    <article className='third-section glass'>
                        <Badges/>
                    </article>
                    <article className='fourth-section glass'>

                    </article>
                    <article className='fifth-section glass'>
                        <AchievementPanel/>
                    </article>
                </section>
            </div>
           
        </>   
    );
}

export default Progress;