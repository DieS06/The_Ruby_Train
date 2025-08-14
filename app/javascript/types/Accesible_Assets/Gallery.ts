type SlideItem = {
    id?: string | number;
    content: React.ReactNode;
    label?: string;
}

type CarouselItem = {
    items: SlideItem[];
    autoPlay?: boolean;
    intervalMs?: number;
    pauseOnHover?: boolean;
    fullscreen?: boolean;
    ariaLabel?: string;
    onIndexChange?: (i: number) => void;
}

export type { SlideItem, CarouselItem };