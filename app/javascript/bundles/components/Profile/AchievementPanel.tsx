import React from 'react';
import CircularProgress from './CircularProgressBar';
import '../../../styles/components/Profile/AchievementPanel.scss';

const AchievementPanel: React.FC = () => {
  return (
    <section className="achievement-panel">
        <article className='achievement-header'>
            <h3>Course Progress</h3>
            <CircularProgress progress={50} />
        </article>
        <article className='achievement-body'>

        </article>
        <article className='achievement-footer'>

        </article>
    </section>
  );
};

export { AchievementPanel };