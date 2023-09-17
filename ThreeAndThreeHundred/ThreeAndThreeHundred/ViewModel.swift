//
//  ViewModel.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/3.
//

import SwiftUI
import RealityKit

/// The data that the app uses to configure its views.
@Observable
class ViewModel {
    
    var isThreeHundred: Bool = false
    var threeHundredRoot: Entity = Entity()
    
    var starModelEntity: StarEntity?
}
