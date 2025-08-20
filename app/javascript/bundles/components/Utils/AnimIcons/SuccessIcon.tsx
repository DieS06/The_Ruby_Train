import AnimatedIcon from './AnimatedIcon';
import successAnim from '../../../../assets/lotties/Success.json';

interface SuccessIconProps {
  completed?: boolean;
  size?: number;
  onReady?: () => void;
}

function SuccessIcon({ completed = true, size = 32, onReady }: SuccessIconProps) {
  return (
    <AnimatedIcon
      animationData={successAnim}
      completed={completed}
      size={size}
      onReady={onReady}
    />
  );
}

export default SuccessIcon;