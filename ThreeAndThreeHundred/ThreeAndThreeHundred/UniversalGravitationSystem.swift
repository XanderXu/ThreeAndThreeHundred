//
//  UniversalGravitationSystem.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/9.
//

import RealityKit

struct UniversalGravitationComponent: Component {
    // speed
    var direction: SIMD3<Double>
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
            guard let star = star as? StarEntity else { continue }
            var force: SIMD3<Double> = .zero
            for otherStar in stars {
                if otherStar == star { continue }
                guard let otherSunMass = otherStar.components[UniversalGravitationComponent.self]?.mass else { continue }
                
                let distanceSquared = Double(distance_squared(otherStar.position, star.position))
                let actingForce = (G * otherSunMass) / (distanceSquared + Double.leastNormalMagnitude)
                
                let direction = SIMD3<Double>(normalize(otherStar.position - star.position))
                force += max(actingForce, 0.005) * direction
            }
            
            let massAdjustedTimesForce = force * context.deltaTime
            star.components[UniversalGravitationComponent.self]!.direction += massAdjustedTimesForce
            star.position += SIMD3<Float>(star.direction * context.deltaTime)
        }
    }
}

