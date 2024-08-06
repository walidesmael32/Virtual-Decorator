

 
import SwiftUI
 
@main
struct Virtual_DecoratorApp: App {
    @State private var showModel1 = false
    @State private var showModel2 = false
 
    var body: some Scene {
        WindowGroup {
            ContentView(showModel1: $showModel1, showModel2: $showModel2)
        }
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(showModel1: $showModel1, showModel2: $showModel2)
        }
    }
}
