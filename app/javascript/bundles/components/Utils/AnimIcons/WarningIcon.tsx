import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import warningAnim from '../../../../assets/lotties/Alert.json';

function WarningIcon({completed = true, size = 32, onReady}: {completed?: boolean; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={warningAnim}
            size={size}
            loop={completed}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default WarningIcon;