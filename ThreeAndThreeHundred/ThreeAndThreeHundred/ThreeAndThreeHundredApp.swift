//
//  ThreeAndThreeHundredApp.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/3.
//

import SwiftUI

@main
struct ThreeAndThreeHundredApp: App {
    @State private var model = ViewModel()
    @State private var immersionStyle: ImmersionStyle = .full
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: $immersionStyle, in: .full)
    }
    
    init() {
        // Register all the custom components and systems that the app uses.
        UniversalGravitationSystem.registerSystem()
    }
}
