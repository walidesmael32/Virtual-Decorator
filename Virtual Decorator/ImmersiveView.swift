import SwiftUI
import RealityKit
 
import RealityKitContent
 
struct ImmersiveView: View {
 
    @Binding var showModel1: Bool
 
    @Binding var showModel2: Bool
 
    @State private var selectedEntity: Entity?
 
    @State private var entityPositions: [String: SIMD3<Float>] = [:] // Dictionary to store entity positions
 
    var body: some View {
 
        RealityView { content in
 
            // Add or remove models based on state variables
            if showModel1 {
                if let scene1 = try? await Entity(named: "Chair1", in: realityKitContentBundle) {
                    scene1.name = "Chair1"
    
                    scene1.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    scene1.generateCollisionShapes(recursive: true)
    
                
                    content.add(scene1)
                }
            }
            if showModel2 {
                if let scene2 = try? await Entity(named: "Table1", in: realityKitContentBundle) {
                  
                    scene2.name = "Table1"
                 
                    scene2.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    scene2.generateCollisionShapes(recursive: true)
                   
                  
                    content.add(scene2)
                }
            }
        }
        .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let entity = value.entity
                        if let parent = entity.parent {
                            selectedEntity = entity
                            selectedEntity?.position = value.convert(value.location3D, from: .local, to: parent)
                        }
                    }
                    .onEnded { _ in }
            )
        .gesture(
            RotationGesture()
                .onChanged { value in
                    guard let entity = selectedEntity else { return }
                    let currentRotation = entity.transform.rotation
                    let additionalRotation = simd_quatf(angle: Float(value.radians) * 0.1, axis: [0, 0, 1])
                    entity.transform.rotation = additionalRotation * currentRotation
                }
                .onEnded { _ in }
        )
    }
 

}
 
 
