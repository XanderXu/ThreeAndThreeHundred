//
//  StarEntity.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/9.
//

import RealityKit
import RealityKitContent

class StarEntity: Entity {
    var speed: SIMD3<Double> {
        components[UniversalGravitationComponent.self]!.speed
    }
    
    var mass: Double {
        components[UniversalGravitationComponent.self]!.mass
    }
    
    private let star: Entity
    
    init(position: SIMD3<Float>, initialSpeed: SIMD3<Double> = .zero, mass: Double = 1e6) async {
        do {
            self.star = try await Entity(named: "Sun", in: realityKitContentBundle)
        } catch {
            fatalError("Failed to load a model asset.")
        }
        super.init()
        addChild(star)
        
        self.position = position
        components[UniversalGravitationComponent.self] = UniversalGravitationComponent(speed: initialSpeed, mass: mass)
    }
    
    @MainActor required init() {
        star = Entity()
    }
}
