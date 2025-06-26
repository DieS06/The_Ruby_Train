import { useRef, forwardRef, useImperativeHandle } from 'react';
import Lottie, { type LottieRefCurrentProps } from 'lottie-react';
import type { LottieControl, IconLottie } from '../../types/lottie';

interface Props extends IconLottie {
    onReady?: () => void;
}

const IconHandleLottie = forwardRef<LottieControl, Props>(
    ({ animationData, size = 24, loop = false, autoplay = false, onReady }, ref) => {
        const lottieRef = useRef<LottieRefCurrentProps>(null);
        
        useImperativeHandle(ref, () => ({
            play: () => lottieRef.current?.play(),
            stop: () => lottieRef.current?.stop(),
            goToFrame: (frame: number) => lottieRef.current?.goToAndStop(frame, true),
            playSegments: (segments: [number, number]) => lottieRef.current?.playSegments(segments, true),
        }));

        return (
                <Lottie
                    style ={{ width: size, height: size }}
                    lottieRef={lottieRef}
                    animationData={animationData}
                    loop={loop}
                    autoplay={autoplay}
                    onDOMLoaded={onReady}
                />
        );
    }
);
export default IconHandleLottie;