import React, { useEffect, useState, useRef } from 'react';
import { ChevronLeft, ChevronRight } from "lucide-react";
import { CarouselItem as CarouselConfig } from "../../../types/Accesible_Assets/Gallery";
import "../../../styles/components/Accesible_Assets/Gallery.scss";

type Props = {
   CarouselItem: CarouselConfig;
}

function GalleryCarousel({
   CarouselItem
}: Props) {
    const items = Array.isArray(CarouselItem?.items) ? CarouselItem.items : [];
    const autoPlay = CarouselItem?.autoPlay ?? true;
    const intervalMs = CarouselItem?.intervalMs ?? 5000;
    const pauseOnHover = CarouselItem?.pauseOnHover ?? true;
    const fullscreen = CarouselItem?.fullscreen ?? false;
    const ariaLabel = CarouselItem?.ariaLabel ?? "Carousel";

    const total = CarouselItem.items?.length ?? 0;
    const [index, setIndex] = useState(0);
    const intervalRef = useRef<number | null>(null);
    const hoveredRef = useRef(false);
    const next = () => setIndex(prev => (prev + 1) % CarouselItem.items.length);
    const prev = () => setIndex(prev => (prev - 1 + CarouselItem.items.length) % CarouselItem.items.length);
    const goTo = (i: number) => setIndex(i);

    useEffect(() => {
        if (index >= total) setIndex(0);
    }, [total, index]);

    const start = () => {
        if (!CarouselItem.autoPlay || total <= 1) return;
        stop();
        intervalRef.current = window.setInterval(() => {
        if (!hoveredRef.current && !document.hidden) next();
        }, CarouselItem.intervalMs);
    };

    const stop = () => {
        if (intervalRef.current != null) {
        clearInterval(intervalRef.current);
        intervalRef.current = null;
        }
    };

    useEffect(() => {
        start();
        const onVis = () => (document.hidden ? stop() : start());
        document.addEventListener("visibilitychange", onVis);
        return () => {
            stop();
            document.removeEventListener("visibilitychange", onVis);
        };
    }, [CarouselItem.autoPlay, CarouselItem.intervalMs, total]);

    useEffect(() => {
        CarouselItem.onIndexChange?.(index);
    }, [index, CarouselItem.onIndexChange]);

    if (total === 0) {
        if (typeof process !== "undefined" && process.env.NODE_ENV !== "production") {
        console.warn("[GalleryCarousel] No hay items para mostrar.");
    }
        return null;
    }

    return (
        <div className={`gallery-carousel ${CarouselItem.fullscreen ? "fullscreen" : ""}`}
            role="region"
            aria-roledescription="carousel"
            aria-label={CarouselItem.ariaLabel}
            onMouseEnter={() => { if (CarouselItem.pauseOnHover) hoveredRef.current = true; }}
            onMouseLeave={() => { if (CarouselItem.pauseOnHover) hoveredRef.current = false; }}
        >
            <button className="nav-button left" onClick={() => { prev(); start(); }} aria-label="Previous slide">
                <ChevronLeft size={20} />
            </button>

            <div className="carousel-item" aria-live="polite">
                {CarouselItem.items[index].content}
            </div>

            <button className="nav-button right" onClick={() => { next(); start(); }} aria-label="Next slide">
                <ChevronRight size={20} />
            </button>

            <div className="carousel-dots" role="tablist" aria-label="Slides">
                {CarouselItem.items.map((_, i) => (
                    <button
                        key={CarouselItem.items[i]?.id ?? i}
                        role="tab"
                        aria-selected={i === index}
                        aria-label={`Go to slide ${i + 1}`}
                        className={`dot ${i === index ? "active" : ""}`}
                        onClick={() => { goTo(i); start(); }}
                    />
                ))}
            </div>
        </div>
    );
};

export { GalleryCarousel };