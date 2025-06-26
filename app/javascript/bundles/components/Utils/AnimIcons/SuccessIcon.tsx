import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import successAnim from '../../../../assets/lotties/Success.json';

function SuccessIcon({completed = true, size = 32, onReady}: {completed?: boolean; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={successAnim}
            size={size}
            loop={completed}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default SuccessIcon;