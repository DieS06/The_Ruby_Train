import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import errorAnim from '../../../../assets/lotties/Error.json';

function ErrorIcon({completed = true, className = "error-icon",size = 24, onReady}:
    {completed?: boolean; className?: string; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={errorAnim}
            size={size}
            loop={completed}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default ErrorIcon;