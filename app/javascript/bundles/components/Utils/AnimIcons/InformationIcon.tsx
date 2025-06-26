import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import infoAnim from '../../../../assets/lotties/Information.json';

function InfoIcon({completed = true, size = 32, onReady}: {completed?: boolean; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={infoAnim}
            size={size}
            loop={completed}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default InfoIcon;