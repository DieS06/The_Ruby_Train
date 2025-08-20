import { useEffect } from 'react';
import IconHandleLottie from '../../../../services/Lottie/IconHandleLottie';

interface AnimatedIconProps {
  animationData: any;
  completed?: boolean;
  size?: number;
  className?: string;
  onReady?: () => void;
}

function AnimatedIcon({ 
  animationData, 
  completed = true, 
  size = 32, 
  className = '',
  onReady 
}: AnimatedIconProps) {

  useEffect(() => {
    if (completed && onReady) {
      onReady();
    }
  }, [completed, onReady]);

  return (
    <IconHandleLottie
      animationData={animationData}
      size={size}
      loop={completed}
      autoplay={completed}
      onReady={onReady}
      className={className}
    />
  );
}

export default AnimatedIcon;