/*----------------------------------------------------
LOTTIE HANDLE ANIMATIONS INTERFACE
----------------------------------------------------**/
export interface LottieControl{
    play: () => void;
    stop: () => void;
    goToFrame: (frame: number) => void;
    playSegments: (segments: [number, number]) => void;
}

export type HandlePlay = Pick<IconHandle, 'play'>;
export type HandleStop = Pick<IconHandle, 'stop'>;
export type HandleGoToFrame = Pick<IconHandle, 'goToFrame'>;
export type HandlePlaySegments = Pick<IconHandle, 'playSegments'>;

export interface IconLottie {
    animationData: object;
    size?: number;
    loop?: boolean;
    autoplay?: boolean;
}

export type IconAnimationData = Pick<IconLottie, 'animationData'>;
export type IconSize = Pick<IconLottie, 'size'>;
export type IconLoop = Pick<IconLottie, 'loop'>;
export type IconAutoplay = Pick<IconLottie, 'autoplay'>;
/*----------------------------------------------------

----------------------------------------------------**/