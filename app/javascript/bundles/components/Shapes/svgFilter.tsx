import React, { useEffect, useRef } from "react";

const GlassFilter: React.FC = () => {
    const turbulenceRef = useRef<SVGFETurbulenceElement | null>(null);

    useEffect(() => {
        let frameId: number;
        let t = 0;

        const animate = () => {
            if (turbulenceRef.current) {
                const freqX = 0.01 + Math.sin(t) * 0.005;
                const freqY = 0.02 + Math.cos(t) * 0.005;
                turbulenceRef.current.setAttribute("baseFrequency", `${freqX} ${freqY}`);
            }
            t += 0.02;
            frameId = requestAnimationFrame(animate);
            };

            animate();
            return () => cancelAnimationFrame(frameId);
        }, []);

    return (
        <svg width="0" height="0" style={{ position: "absolute" }}>
            <filter id="glass-distort">
                <feTurbulence
                    ref={turbulenceRef}
                    type="turbulence"
                    baseFrequency="0.01 0.02"
                    numOctaves="1"
                    result="turb"
                />
                <feDisplacementMap
                    in="SourceGraphic"
                    in2="turb"
                    scale="10"
                    xChannelSelector="R"
                    yChannelSelector="G"
                />
            </filter>
        </svg>
    );
};

export { GlassFilter };