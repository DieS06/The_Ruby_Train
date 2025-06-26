import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';
import helpAnim from '../../../../assets/lotties/Help.json';

function HelpIcon({completed = true, loop = true, size = 32, onReady}: 
    {completed?: boolean; loop?: boolean; size?: number; onReady?: () => void}) {
    useEffect(() => {
        if (completed && onReady) {
            onReady();
        }
    }, [completed, onReady]);

    return (
        <IconHandleLottie
            animationData={helpAnim}
            size={size}
            loop={loop}
            autoplay={completed}
            onReady={onReady}
        />
    );
}

export default HelpIcon;