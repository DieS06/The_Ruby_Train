// Objects/SceneContent.tsx – Contenido mínimo de la escena (carga modelo + objeto físico)
import React, { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import { useBox } from '@react-three/cannon';
import { useGLTF, Environment, OrbitControls } from '@react-three/drei';

const SceneContent: React.FC = () => {
  // Cargar un modelo GLTF (e.g., un árbol o personaje)
  const gltf = useGLTF('/models/example.glb'); // suponiendo archivo en public/models:contentReference[oaicite:31]{index=31}
  
  // Añadir un cubo físico como ejemplo (usando Cannon)
  const [cubeRef] = useBox(() => ({ mass: 1, position: [0, 2, 0] })); 

  // Animar lentamente el cubo rotándolo cada frame
  useFrame(() => {
    if (cubeRef.current) {
      cubeRef.current.rotation.y += 0.01;
    }
  });

  return (
    <>
      {/* Modelo importado */}
      <primitive object={gltf.scene} position={[0, 0, 0]} />

      {/* Suelo estático (sin masa) para que el cubo caiga sobre él */}
      <mesh rotation-x={-Math.PI/2} receiveShadow>
        <planeGeometry args={[10, 10]} />
        <meshStandardMaterial color="#777" />
      </mesh>

      {/* Cubo físico que cae sobre el plano */}
      <mesh ref={cubeRef} castShadow>
        <boxGeometry args={[1, 1, 1]} />
        <meshStandardMaterial color="orange" />
      </mesh>

      {/* Entorno HDRI para iluminación global */}
      <Environment preset="sunset" background />

      {/* Controles de cámara orbital */}
      <OrbitControls enableDamping={true} />
    </>
  );
};

export default SceneContent;