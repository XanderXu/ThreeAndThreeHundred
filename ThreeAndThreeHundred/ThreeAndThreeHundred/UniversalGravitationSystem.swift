//
//  UniversalGravitationSystem.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/9.
//

import RealityKit

struct UniversalGravitationComponent: Component {
    var speed: SIMD3<Double>
    var mass: Double
}

let G: Double = 6.673e-11

/// A system that rotates entities with a rotation component.
struct UniversalGravitationSystem: System {
    static let query = EntityQuery(where: .has(UniversalGravitationComponent.self))

    init(scene: RealityKit.Scene) {}

    func update(context: SceneUpdateContext) {
        let stars = context.entities(matching: Self.query, updatingSystemWhen: .rendering)
        for star in stars {
            var acceleration: SIMD3<Double> = .zero
            for otherStar in stars {
                if otherStar == star { continue }
                let otherSunMass = otherStar.components[UniversalGravitationComponent.self]!.mass
                
                let distanceSquared = Double(distance_squared(otherStar.position, star.position))
                let actingForce = (G * otherSunMass) / (distanceSquared + Double.leastNormalMagnitude)
                
                let direction = SIMD3<Double>(normalize(otherStar.position - star.position))
                acceleration += max(actingForce, 0.002) * direction
            }
            star.components[UniversalGravitationComponent.self]!.speed += acceleration * context.deltaTime
        }
        // 计算完成后，再统一更新位置，避免边遍历边修改造成逻辑上的误差
        for case let star as StarEntity in stars {
            star.position += SIMD3<Float>(star.speed * context.deltaTime)
        }
    }
}

