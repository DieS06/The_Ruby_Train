import AnimatedIcon from './AnimatedIcon';
import infoAnim from '../../../../assets/lotties/Information.json';

interface InfoIconProps {
  completed?: boolean;
  size?: number;
  onReady?: () => void;
}

function InfoIcon({ completed = true, size = 32, onReady }: InfoIconProps) {
  return (
    <AnimatedIcon
      animationData={infoAnim}
      completed={completed}
      size={size}
      onReady={onReady}
    />
  );
}

export default InfoIcon;