// import * as THREE from 'three'

// import Sizes from '../Utils/Sizes'
// import Time from '../Utils/Time'
// import Camera from './Camera'
// import Renderer from './Renderer'
// import World from '../Objects/World'
// import Resources from '../Utils/Resources'
// import Debug from '../Utils/Debug'

// import sources from './sources'

let instance: Engine | null = null

export default class Engine {
  static instance: Engine
//   canvas: HTMLCanvasElement
//   sizes: Sizes
//   time: Time
//   scene: THREE.Scene
//   resources: Resources
//   debug: Debug
//   camera: Camera
//   renderer: Renderer
//   world: World

  constructor(canvas: HTMLCanvasElement) {
    if (instance) {
      return instance
    }

    instance = this
    Engine.instance = this

    // Global access (solo en desarrollo o debugging)
    // @ts-ignore
    window.engine = this

    // this.canvas = canvas

    // // Core setup
    // this.sizes = new Sizes()
    // this.time = new Time()
    // this.scene = new THREE.Scene()
    // this.resources = new Resources(sources)
    // this.debug = new Debug()
    // this.camera = new Camera(this)
    // this.renderer = new Renderer(this)
    // this.world = new World(this)

    // this.sizes.on('resize', () => this.resize())
    // this.time.on('tick', () => this.update())
  // }

//   resize(): void {
//     this.camera.resize()
//     this.renderer.resize()
//   }

//   update(): void {
//     this.camera.update()
//     this.world.update()
//     this.renderer.update()
//   }

//   destroy(): void {
//     this.sizes.off('resize')
//     this.time.off('tick')

//     this.scene.traverse((child) => {
//       if (child instanceof THREE.Mesh) {
//         child.geometry.dispose()

//         const material = child.material
//         if (Array.isArray(material)) {
//           material.forEach((m) => m.dispose?.())
//         } else {
//           for (const key in material) {
//             const value = (material as any)[key]
//             if (value && typeof value.dispose === 'function') {
//               value.dispose()
//             }
//           }
//         }
//       }
//     })

//     this.camera.controls?.dispose()
//     this.renderer.instance?.dispose()
//     if (this.debug.active) {
//       this.debug.destroy()
//     }
  }
}
