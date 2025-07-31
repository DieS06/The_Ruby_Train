import React from 'react';
import LoadIcon from '../Utils/AnimIcons/LoadingIcon';
import "../../../styles/components/Loading/Spinner.scss";

interface SpinnerProps {
  size?: number
  loop?: boolean
  className?: string
  onReady?: () => void
}

const Spinner: React.FC<SpinnerProps> = ({
  size = 120,
  loop = true,
  className = "spinner",
  onReady,
}) => {
  return (
    <div className={`${className}`}>
      <LoadIcon
        className={className}
        size={size}
        loop={loop}
        onReady={onReady}
      />
      <h3 className='loading-text'>Loading...</h3>
    </div>
  );
};

export default Spinner;