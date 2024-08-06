import SwiftUI
import RealityKit
import RealityKitContent
 
struct ContentView: View {
    @Binding var showModel1: Bool
    @Binding var showModel2: Bool
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var body: some View {
        VStack {
           Button(action: {
                Task {
                    await refreshImmersiveSpace()
                }
            }) {
                Text("Refreshhh")
                    .font(.title)
                    .frame(width: 360)
                    .padding(24)
            }
            Toggle("Show Model 1", isOn: $showModel1)
                .padding()
                .onChange(of: showModel1) { _, _ in
                    Task {
                        await refreshImmersiveSpace()
                    }
                }
            Toggle("Show Model 2", isOn: $showModel2)
                .padding()
                .onChange(of: showModel2) { _, _ in
                    Task {
                        await refreshImmersiveSpace()
                    }
                }
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
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
    private func refreshImmersiveSpace() async {
        if immersiveSpaceIsShown {
            // Dismiss the immersive space first
            await dismissImmersiveSpace()
            immersiveSpaceIsShown = false
        }
        // Set to false to ensure refresh logic is correct
        showImmersiveSpace = false
        // Wait for a brief moment before reopening
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second delay
        showImmersiveSpace = true
        // Reopen the immersive space
        switch await openImmersiveSpace(id: "ImmersiveSpace") {
        case .opened:
            immersiveSpaceIsShown = true
        case .error, .userCancelled:
            fallthrough
        @unknown default:
            immersiveSpaceIsShown = false
            showImmersiveSpace = false
        }
    }
}
