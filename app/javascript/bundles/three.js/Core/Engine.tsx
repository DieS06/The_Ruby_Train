import React, { Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Physics } from '@react-three/cannon';
import { Leva } from 'leva';
import SceneContent from '../Objects/SceneContent';

const EngineCanvas: React.FC = () => {
  return (
    <Canvas className='profile-background' shadows camera={{ position: [0, 1.5, 5], fov: 75 }}>
      {/* Debug UI (Leva) - colapsada por defecto */}
      <Leva collapsed />

      {/* Luces de ejemplo */}
      <ambientLight intensity={0.5} />
      <pointLight position={[5, 5, 5]} />

      {/* Mundo físico con gravedad usando Cannon */}
      <Physics gravity={[0, -9.81, 0]}>
        <Suspense fallback={null}>
          <SceneContent /> {/* Contenido de la escena 3D */}
        </Suspense>
      </Physics>
    </Canvas>
  );
};

export default EngineCanvas;
