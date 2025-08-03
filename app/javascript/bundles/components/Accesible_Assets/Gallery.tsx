import React, { useEffect, useState, useRef } from 'react';
import { ChevronLeft, ChevronRight } from "lucide-react";
import { items } from './GalleryItems';
import "../../../styles/components/Accesible_Assets/Gallery.scss";

function GalleryCarousel() {
    const [index, setIndex] = React.useState(0);
    const intervalRef = useRef<NodeJS.Timeout | null>(null);

    const next = () => setIndex(prev => (prev + 1) % items.length);
    const prev = () => setIndex(prev => (prev - 1 + items.length) % items.length);
    
    const goTo = (i: number) => setIndex(i);

    const resetInterval = () => {
        if (intervalRef.current) clearInterval(intervalRef.current);
        intervalRef.current = setInterval(next, 5000);
    };

    useEffect(() => {
        intervalRef.current = setInterval(next, 5000);
        return () => {
            if (intervalRef.current) {
            clearInterval(intervalRef.current);
            }
        };
    }, []);

    return (
        <div className="gallery-carousel">
            <button className="nav-button left" onClick={() => { prev(); resetInterval(); }}>
                <ChevronLeft size={20} />
            </button>

            <div className="carousel-item">{items[index].content}</div>

            <button className="nav-button right" onClick={() => { next(); resetInterval(); }}>
                <ChevronRight size={20} />
            </button>

            <div className="carousel-dots">
                {items.map((_, i) => (
                <span
                    key={i}
                    className={`dot ${i === index ? "active" : ""}`}
                    onClick={() => { goTo(i); resetInterval(); }}
                />
                ))}
            </div>
        </div>
    );
};

export { GalleryCarousel };