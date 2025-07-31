import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import loadAnim from '@/assets/lotties/Loading.json';

function LoadIcon({completed = true, loop = true, className = "spinner",  size = 32, onReady}:
    {completed?: boolean; loop?: boolean; className?: string; size?: number; onReady?: () => void}) {
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