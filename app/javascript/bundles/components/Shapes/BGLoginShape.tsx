import React from "react";
import "../../../styles/components/Shapes/BGLoginShape.scss";

export default function BGLoginShape() {
  return (
<svg
      className="auth-shape-bg"
      viewBox="0 0 1991 1462"
      preserveAspectRatio="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <linearGradient
          id="bgFillGradient"
          x1="1968"
          y1="730.75"
          x2="23"
          y2="730.75"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stopColor="#F0F0F0" />
          <stop offset="0.4" stopColor="#F0F0F0" stopOpacity="0.8" />
          <stop offset="0.75" stopColor="white" stopOpacity="0" />
        </linearGradient>

        <linearGradient
          id="outlineStrokeGradient"
          x1="22.9997"
          y1="740"
          x2="1387.5"
          y2="1175"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stopColor="white" />
          <stop offset="0.285722" stopColor="#FAFDFE" />
          <stop offset="0.913524" stopColor="#DB4848" />
        </linearGradient>
      </defs>

      <path
        d="M11.5002 11.5V1013.5H842.567L1190.04 1445.71L1193.49 1450H1979.5V11.5H11.5002Z"
        fill="url(#bgFillGradient)"
        stroke="url(#outlineStrokeGradient)"
        strokeWidth="23"
      />
    </svg>
  );
}
