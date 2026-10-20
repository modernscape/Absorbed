//
//  VolumeView.swift
//  Absorbed
//
//  Created by forest on 2024/04/03.
//

import SwiftUI
import SceneKit
struct VolumeView: View {
    
    init() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 5, z: 5)
        scene?.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.white
        scene?.rootNode.addChildNode(ambientLightNode)
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.2)
        box.materials.first?.diffuse.contents = UIColor.lightGray
        let boxNode = SCNNode(geometry: box)
        scene?.rootNode.addChildNode(boxNode)
    }
    
    var scene = SCNScene(named: "MyScene.scn")
    
    var cameraNode: SCNNode? {
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }
    
    var body: some View {
        SceneView(
            scene: scene,
            pointOfView: cameraNode,
            options: []
        )
    }
}

#Preview {
    VolumeView()
}
