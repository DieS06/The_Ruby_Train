import AnimatedIcon from './AnimatedIcon';
import errorAnim from '../../../../assets/lotties/Error.json';

interface ErrorIconProps {
  completed?: boolean;
  className?: string;
  size?: number;
  onReady?: () => void;
}

function ErrorIcon({ 
  completed = true, 
  className = "error-icon", 
  size = 24, 
  onReady 
}: ErrorIconProps) {
  return (
    <AnimatedIcon
      animationData={errorAnim}
      completed={completed}
      size={size}
      className={className}
      onReady={onReady}
    />
  );
}

export default ErrorIcon;