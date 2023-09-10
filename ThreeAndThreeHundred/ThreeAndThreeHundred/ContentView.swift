//
//  ContentView.swift
//  ThreeAndThreeHundred
//
//  Created by 许同学 on 2023/9/3.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @Environment(ViewModel.self) private var model
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model
        VStack {
            Model3D(named: "Sun.usda", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("303 body!")
                .font(.title)

            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
            
            Toggle("Show three hundred", isOn: $model.isThreeHundred)
                .toggleStyle(.switch)
                .padding(.top, 50)
                .frame(width: 300)
                .disabled(!showImmersiveSpace)
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    model.isThreeHundred = false
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
