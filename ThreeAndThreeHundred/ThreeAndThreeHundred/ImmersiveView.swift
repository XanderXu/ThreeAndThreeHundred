//
//  ImmersiveView.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/3.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(ViewModel.self) private var model
    @State private var subscriptions = [EventSubscription]()
    var body: some View {
        RealityView { content in
            // Create a material with a star field on it.
            guard let resource = try? await TextureResource(named: "Starfield") else {
                // If the asset isn't available, something is wrong with the app.
                fatalError("Unable to load starfield texture.")
            }
            var material = UnlitMaterial()
            material.color = .init(texture: .init(resource))

            // Attach the material to a large sphere.
            let entity = Entity()
            entity.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1000),
                materials: [material]
            ))

            // Ensure the texture image points inward at the viewer.
            entity.scale *= .init(x: -1, y: 1, z: 1)
            content.add(entity)
            
            var directions: [SIMD3<Double>] = []
            for _ in 0..<2 {
                let direction = SIMD3<Double>.random(in: -0.05...0.05)
                directions.append(direction)
            }
            directions.append(SIMD3<Double>.zero - directions[0] - directions[1])
            
            for i in 0..<3 {
                let randomPosition = SIMD3<Float>(x: Float.random(in: -0.5...0.5), y: 1.5 + Float.random(in: -0.2...0.2), z: -0.5 + Float.random(in: -0.2...0.2))
                if let referenceModel = model.starModelEntity {
                    let sun = referenceModel.clone(recursive: true)
                    sun.position = randomPosition
                    sun.speed = directions[i]
                    sun.name = "\(i)"
                    content.add(sun)
                } else {
                    let sun = await StarEntity(position: randomPosition, initialSpeed: directions[i])
                    sun.name = "\(i)"
                    content.add(sun)
                    model.starModelEntity = sun
                }
            }
            model.threeHundredRoot = Entity()
            content.add(model.threeHundredRoot)
            model.threeHundredRoot.name = "root"
            
//            subscriptions.append(content.subscribe(to: SceneEvents.Update.self) { context in
//                guard let root = context.scene.findEntity(named: "root") else {return}
//                guard let star0 = context.scene.findEntity(named: "0") else {return}
//                guard let star1 = context.scene.findEntity(named: "1") else {return}
//                guard let star2 = context.scene.findEntity(named: "2") else {return}
//                let stars = root.children + [star0, star1, star2]
//                for star in stars {
//                    var acceleration: SIMD3<Double> = .zero
//                    for otherStar in stars {
//                        if otherStar == star { continue }
//                        let otherSunMass = otherStar.components[UniversalGravitationComponent.self]!.mass
//                        
//                        let distanceSquared = Double(distance_squared(otherStar.position, star.position))
//                        let actingForce = (G * otherSunMass) / (distanceSquared + Double.leastNormalMagnitude)
//                        
//                        let direction = SIMD3<Double>(normalize(otherStar.position - star.position))
//                        acceleration += max(actingForce, 0.002) * direction
//                    }
//                    star.components[UniversalGravitationComponent.self]!.speed += acceleration * context.deltaTime
//                }
//                // 计算完成后，再统一更新位置，避免边遍历边修改造成逻辑上的误差
//                for case let star as StarEntity in stars {
//                    star.position += SIMD3<Float>(star.speed * context.deltaTime)
//                }
//            })
        }
        .onChange(of: model.isThreeHundred) { oldValue, newValue in
            Task {
                if newValue {
                    let total = 300
                    for i in 0..<total {
                        let randomPosition = SIMD3<Float>(x: Float.random(in: -10...10), y: 1.5 + Float.random(in: -2...2), z: -0.5 + Float.random(in: -10...10))
                        
                        let sun = model.starModelEntity!.clone(recursive: true)
                        sun.position = randomPosition
                        sun.speed = .zero
                        sun.name = "root-\(i)"
                        if model.isThreeHundred {
                            model.threeHundredRoot.addChild(sun)
                        } else {
                            print("break;")
                            break
                        }
                        if i%100 == 0 || i == total-1 {
                            print("root:i=\(i)")
                        }
                    }
                } else {
                    let newRoot = Entity()
                    newRoot.name = "root"
                    model.threeHundredRoot.parent?.addChild(newRoot)
                    
                    print(model.threeHundredRoot.children.count)
                    model.threeHundredRoot.isEnabled = false
                    model.threeHundredRoot.removeFromParent()
                    model.threeHundredRoot = newRoot
                }
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
