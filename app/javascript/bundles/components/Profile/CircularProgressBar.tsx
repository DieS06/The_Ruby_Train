import React from "react";
import { 
    CircularProgressbar,
    buildStyles 
} from "react-circular-progressbar";
import "react-circular-progressbar/dist/styles.css";
import type { CircularProgressProps } from "../../../types/Profile/CircularProgress";

const CircularProgress: React.FC<CircularProgressProps> = ({ progress }) => (
  <div>
    <CircularProgressbar
      value={progress}
      text={`${progress}%`}
      styles={buildStyles({
        textSize: "0.8rem",
        pathColor: "#DB4848",
        textColor: "#B32222",
        trailColor: "#F0F0F0",
      })}
    />
  </div>
);

export default CircularProgress;