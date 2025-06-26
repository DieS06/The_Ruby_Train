import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import sentsAnim from '../../../../assets/lotties/Paper_Plane.json';

function SentIcon({completed = true, loop = true, className = "sent-icon", size = 32, onReady}:
     {completed?: boolean; loop?: boolean, className: string, size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={sentsAnim}
            size={size}
            loop={loop}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default SentIcon;