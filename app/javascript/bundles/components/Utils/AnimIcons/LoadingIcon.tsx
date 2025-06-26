import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import loadAnim from '../../../../assets/lotties/Loading.json';

function LoadIcon({completed = true, size = 40, onReady}: {completed?: boolean; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={loadAnim}
            size={size}
            loop={completed}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default LoadIcon;