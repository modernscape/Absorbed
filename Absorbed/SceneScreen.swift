import SwiftUI
import SceneKit
import SwiftData
import StoreKit
import AudioToolbox
import Foundation
import SpriteKit


var objCount = 0

//class Obj : SCNNode {
//    var selected = false
//
//}
extension String {
    func split(by length: Int) -> [String] {
        
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}


class SceneCoordinator: NSObject, SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        renderer.debugOptions = [.renderAsWireframe]
    }
}

class RenderDelegate: NSObject, SCNSceneRendererDelegate {
    // dummy render delegate to capture renderer
        
    @AppStorage(KeyString.camera_posX.rawValue) var camera_posX : Double = 0.0
    @AppStorage(KeyString.camera_posY.rawValue) var camera_posY : Double = 2.0
    @AppStorage(KeyString.camera_posZ.rawValue) var camera_posZ : Double = 5.0
    @AppStorage(KeyString.camera_rotX.rawValue) var camera_rotX : Double = -0.980085
    @AppStorage(KeyString.camera_rotY.rawValue) var camera_rotY : Double = -0.195142
    @AppStorage(KeyString.camera_rotZ.rawValue) var camera_rotZ : Double = 0.036788
    @AppStorage(KeyString.camera_rotW.rawValue) var camera_rotW : Double = 0.735900
    @AppStorage(KeyString.focalLength.rawValue) var focalLength : Double = 9.6
    @AppStorage(KeyString.fieldOfView.rawValue) var fieldOfView : Double = 55.0
    
    

    
    var lastRenderer: SCNSceneRenderer!
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // store the renderer for hit testing
        lastRenderer = renderer
//        print(lastRenderer.pointOfView?.position)
        if let p = lastRenderer.pointOfView?.position {
            pos = p
//            print(pos!)

            let r = lastRenderer.pointOfView!.rotation
            
            

            
            camera_posX = Double(p.x)
            camera_posY = Double(p.y)
            camera_posZ = Double(p.z)
            camera_rotX = Double(r.x)
            camera_rotY = Double(r.y)
            camera_rotZ = Double(r.z)
            camera_rotW = Double(r.w)
            
            if let camera = lastRenderer.pointOfView?.camera {
           
                
                focalLength = camera.focalLength
                fieldOfView = camera.fieldOfView
             
            

                
            }
            
//            
//            print(camera_posX)
//            print(camera_posY)
//            print(camera_posZ)
//            print(camera_rotX)
//            print(camera_rotY)
//            print(camera_rotZ)
//            print(camera_rotW)
//            print(focalLength)
//            print(fieldOfView)

            

//            -2.1587557792663574
//            3.4042675495147705
//            2.2873878479003906
//            -0.7138896584510803
//            -0.6747722029685974
//            -0.18719996511936188
//            1.0671725273132324
//            13.609025955200195
//            82.80961608886719
            

      
        }
    }
}

var valueObj : SCNNode!
let plus : Float = 0.01
var objs = [SCNNode]()
var buildIndex = 0
var played = false

var pos : SCNVector3!


/* ----------------------------------------------------------------------------
 MARK: - s
 ------------------------------------------------------------------------------*/

let underScale : CGFloat = 0.0

func resetObj(_ obj: SCNNode) {
    let scale : CGFloat = underScale
    animEffect(obj, scaleY: scale)
}

func buildObj(_ obj: SCNNode) {
    let scale : CGFloat = 2
    animEffect(obj, scaleY: scale)
}

func toggleObj(_ obj: SCNNode) {
    
    let scale : CGFloat = obj.scale.y == 2 ? underScale : 2
    animEffect(obj, scaleY: scale)
}

func animEffect(_ obj: SCNNode, scaleY: CGFloat) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 0.3
    obj.scale = SCNVector3(1, scaleY, 1)
    SCNTransaction.commit()
}

func buildObjs() {
    
    if buildIndex >= objs.count {
        buildIndex = 0
    }
    
    let obj = objs[buildIndex]
    buildObj(obj)
    
    buildIndex += 1
}

func playBuild() {
    
    let interval = 0.05
    for i in 0..<objs.count {
        let delay = interval * Double(i) // 遅延
        let obj = objs[i]
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            buildObj(obj)
        }
    }
    played = true
}

func resetBuild() {
    let interval = 0.02
    
    for i in 0..<objs.count {
        let delay = interval * Double(i) // 遅延
        let obj = objs[i]
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            resetObj(obj)
        }
    }
    played = false
}


/* ----------------------------------------------------------------------------
 MARK: - cylinder
 ------------------------------------------------------------------------------*/

func setValue(value: Float) {
    valueObj.scale = SCNVector3(0.9, value, 0.9)
    let y = -0.5 + valueObj.scale.y/2 + 0.01
    valueObj.position = SCNVector3(0, y, 0)
}

func incrementValue() {
    setValue(value: valueObj.scale.y + plus)
}

func decrementValue() {
    setValue(value: valueObj.scale.y - plus)
}



class SceneModel: ObservableObject {
    let scene_s = makeScene(name: "s.scn")
    let scene_cylinder = makeScene(name: "cylinder.scn")
    var scene_Immersion3D = makeScene_Immersion3D()
    let renderDelegate = RenderDelegate()
    
    func resetScene() {
        scene_Immersion3D = makeScene_Immersion3D()
    }
    
    func resetCameraScene() {
        scene_Immersion3D = makeScene_Immersion3D_reset()
    }
}





func makeScene(name: String) -> SCNScene {
  
    
    let scene = SCNScene(named: name, inDirectory: "art.scnassets/scenes")

    
    if let g = scene!.rootNode.childNode(withName: "group", recursively: true) {
        
        for o in g.childNodes {
            objs.append(o)
        }
        objCount = objs.count
    }
    
    return scene!
}




/* ----------------------------------------------------------------------------
 MARK: - immersion3D
 ------------------------------------------------------------------------------*/

func makeScene_Immersion3D() -> SCNScene {
    
    print("====== makeScene_Immersion3D ======")
    
    @AppStorage(KeyString.camera_posX.rawValue) var camera_posX : Double = 0.0
    @AppStorage(KeyString.camera_posY.rawValue) var camera_posY : Double = 2.0
    @AppStorage(KeyString.camera_posZ.rawValue) var camera_posZ : Double = 5.0
    @AppStorage(KeyString.camera_rotX.rawValue) var camera_rotX : Double = -0.980085
    @AppStorage(KeyString.camera_rotY.rawValue) var camera_rotY : Double = -0.195142
    @AppStorage(KeyString.camera_rotZ.rawValue) var camera_rotZ : Double = 0.036788
    @AppStorage(KeyString.camera_rotW.rawValue) var camera_rotW : Double = 0.735900
    @AppStorage(KeyString.focalLength.rawValue) var focalLength : Double = 9.6
    @AppStorage(KeyString.fieldOfView.rawValue) var fieldOfView : Double = 55.0
    
    if let scene = SCNScene(named: "immersion3D.scn", inDirectory: "art.scnassets/scenes") {
        
        
//        makeCameraOrbit(scene: scene)
        let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.camera?.fieldOfView = fieldOfView
            cameraNode.camera?.focalLength = focalLength
            cameraNode.name = "My3DCamera"
            scene.rootNode.addChildNode(cameraNode)
            cameraNode.position = SCNVector3(x: Float(camera_posX), y: Float(camera_posY), z: Float(camera_posZ))
            cameraNode.rotation = SCNVector4(x: Float(camera_rotX), y: Float(camera_rotY), z: Float(camera_rotZ), w: Float(camera_rotW))
        return scene
    } else {
        return SCNScene()
    }
}

func makeScene_Immersion3D_reset() -> SCNScene {
    
    print("====== makeScene_Immersion3D_reset ======")
    
    @AppStorage(KeyString.camera_posX.rawValue) var camera_posX : Double = 0.0
    @AppStorage(KeyString.camera_posY.rawValue) var camera_posY : Double = 2.0
    @AppStorage(KeyString.camera_posZ.rawValue) var camera_posZ : Double = 5.0
    @AppStorage(KeyString.camera_rotX.rawValue) var camera_rotX : Double = -0.980085
    @AppStorage(KeyString.camera_rotY.rawValue) var camera_rotY : Double = -0.195142
    @AppStorage(KeyString.camera_rotZ.rawValue) var camera_rotZ : Double = 0.036788
    @AppStorage(KeyString.camera_rotW.rawValue) var camera_rotW : Double = 0.735900
    @AppStorage(KeyString.focalLength.rawValue) var focalLength : Double = 9.6
    @AppStorage(KeyString.fieldOfView.rawValue) var fieldOfView : Double = 55.0
    
    if let scene = SCNScene(named: "immersion3D.scn", inDirectory: "art.scnassets/scenes") {
        
        
        //        makeCameraOrbit(scene: scene)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 82.80961608886719
        cameraNode.camera?.focalLength = 13.609025955200195
        cameraNode.name = "My3DCamera"
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: Float(-2.1587557792663574), y: Float(3.4042675495147705), z: Float(2.2873878479003906))
        cameraNode.rotation = SCNVector4(x: Float(-0.7138896584510803), y: Float(-0.6747722029685974), z: Float(    -0.18719996511936188), w: Float(1.0671725273132324))
        return scene
    } else {
        return SCNScene()
    }
    
    

    

}



var cameraOrbit : SCNNode!


func calcAngle(angle: Double) -> Angle {
    return Angle(degrees: angle)

}



struct SceneScreen: View  {
    
    
//    @ObservedObject var cameraObject = CameraObject()
    
    @Environment(\.modelContext) private var modelContext
    
    func changeScale(value: CGFloat, velocity: CGFloat) {
        
        let k = 0.5
        let y = value * k
        
        for o in objs {
            o.scale = SCNVector3(1, y, 1)
        }
    }
    
    var sceneCoordinator = SceneCoordinator()
    
    @ObservedObject var model = SceneModel()
    
    @State private var crownValue = 0.0
    @State private var minValue = -10.0 //-10.0
    @State private var maxValue = 5.0 // 10.0
    @State private var velocity = 0.0
    @State private var isIdle = true
    
    @AppStorage(KeyString.selectedViewPicker.rawValue) var selectedViewPicker = 1
    @AppStorage(KeyString.countUpdateDateStr.rawValue) var countUpdateDateStr = ""

    

    @State var boxes = [SCNNode]()
    

    
    func setBody(node: SCNNode) {
        
    }
    
    let boxH = 0.2
    
    
    func initLayout(scene: SCNScene) {
        if let b = scene.rootNode.childNode(withName: "box_0", recursively: true) {
           
            box_0 = b
            let box = SCNBox(width: 1, height: boxH, length: 1, chamferRadius: 0)
            
            
            
            
            box_0.physicsBody = .init(type: .static, shape: .init(geometry: box))
            box_0.physicsBody?.angularDamping = 1
            box_0.physicsBody?.damping = 0.9
            box_0.physicsBody?.rollingFriction = 0
            box_0.physicsBody?.friction = 0
            box_0.physicsBody?.restitution = 0
            
            
        }
        
        if let b = scene.rootNode.childNode(withName: "box_1", recursively: true) {
            box_1 = b
            let box = SCNBox(width: 1, height: boxH, length: 1, chamferRadius: 0)
            
            box_1.physicsBody = .init(type: .static, shape: .init(geometry: box))
            box_1.physicsBody?.angularDamping = 1
            box_1.physicsBody?.damping = 0.9
            box_1.physicsBody?.rollingFriction = 0
            box_1.physicsBody?.friction = 0
            box_1.physicsBody?.restitution = 0
            
        }
        
        
        if let b = scene.rootNode.childNode(withName: "box_2", recursively: true) {
            box_2 = b
            let box = SCNBox(width: 1, height: boxH, length: 1, chamferRadius: 0)
            
            box_2.physicsBody = .init(type: .static, shape: .init(geometry: box))
            
            box_2.physicsBody = .init(type: .static, shape: .init(geometry: box))
            box_2.physicsBody?.angularDamping = 1
            box_2.physicsBody?.damping = 0.9
            box_2.physicsBody?.rollingFriction = 0
            box_2.physicsBody?.friction = 0
            box_2.physicsBody?.restitution = 0
            
            
            
        }
        
        boxes.removeAll()
        
        boxes.append(box_0)
        boxes.append(box_1)
        boxes.append(box_2)
        
        for i in 0..<itemsForVolume.count {
            boxes[i].geometry?.firstMaterial?.diffuse.contents = UIColor(colors[itemsForVolume[i].catIndex])
        }
        
        switch itemsForVolume.count {
        case 0:
            box_0.isHidden = true
            box_1.isHidden = true
            box_2.isHidden = true
            
        case 1:
            box_0.isHidden = false
            box_1.isHidden = true
            box_2.isHidden = true
            
            box_0.position = SCNVector3(x: 0, y: 0, z: 0)
            
        case 2:
            box_0.isHidden = false
            box_1.isHidden = false
            box_2.isHidden = true
            
            box_0.position = SCNVector3(x: -offset, y: 0, z: 0)
            box_1.position = SCNVector3(x: offset, y: 0, z: 0)
            //
        case 3:
            box_0.isHidden = false
            box_1.isHidden = false
            box_2.isHidden = false
            
            box_0.position = SCNVector3(x: 0, y: 0, z: -offset)
            box_1.position = SCNVector3(x: -offset, y: 0, z: offset)
            box_2.position = SCNVector3(x: offset, y: 0, z: offset)
            
        default:
            break
        }
        
        
        for i in 0..<itemsForVolume.count {
            let box = boxes[i]
            box.geometry?.firstMaterial?.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
            makeText(parent: box, str: itemsForVolume[i].title, numStr: "", color: UIColor(colors[itemsForVolume[i].catIndex]))
            
        }
        
        
        
        
        slices.removeAll()
        
        if let s0 = scene.rootNode.childNode(withName: "slice_0", recursively: true) {
            slices.append(s0)
        }
        
        if let s1 = scene.rootNode.childNode(withName: "slice_1", recursively: true) {
            slices.append(s1)
        }
        
        if let s2 = scene.rootNode.childNode(withName: "slice_2", recursively: true) {
            slices.append(s2)
        }
        
        

        makeSlices()
    }
    
    func makeText(parent: SCNNode, str: String, numStr: String, color: UIColor) {
        
        let a = Float(Double.pi/2.0)
        let b : Float = 1.5
        let b_2 : Float = 0.5
        let z : Float = 0.2
        
        // str
        let text = SCNText(string: str, extrusionDepth: 0.5)
        
        text.font = UIFont(name: "HiraginoSans-W6", size: 100); //.systemFont(ofSize: 10)
        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        let textNode = SCNNode(geometry: text)
        text.firstMaterial?.isDoubleSided = true
        
        let (min, max) = (textNode.boundingBox)
        let w = Float(max.x - min.x)
        let h = Float(max.y - min.y)
        textNode.pivot = SCNMatrix4MakeTranslation(w/2 + min.x, h/2 + min.y, 0)
        
        
        let scale = parent.boundingBox.max.x / textNode.boundingBox.max.x
//        print(str)
//        print(scale)
        
        if scale < 0.0006 {
//            let str_0 = str
            
            let bb : Float = 1.8
     
            let c = ceil(Double(str.count/2))
            let d = Int(c)
//            print(b)
            let strs = str.split(by: d+1)
            for i in 0..<strs.count {
                
                let text_ = SCNText(string: strs[i], extrusionDepth: 0.5)
                text_.font = UIFont(name: "HiraginoSans-W6", size: 100); //.systemFont(ofSize: 10)
                text_.firstMaterial?.diffuse.contents = color
                text_.firstMaterial?.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
                let textNode = SCNNode(geometry: text_)
                text_.firstMaterial?.isDoubleSided = true
                
                let (min, max) = (textNode.boundingBox)
                let w = Float(max.x - min.x)
                let h = Float(max.y - min.y)
                textNode.pivot = SCNMatrix4MakeTranslation(w/2 + min.x, h/2 + min.y, 0)
                
                let scale = parent.boundingBox.max.x / textNode.boundingBox.max.x
                
                textNode.scale = SCNVector3(x: scale*bb, y: scale*bb, z: 0.5)
                textNode.eulerAngles = SCNVector3(x: -a, y: 0, z: 0)
                
                let s : Float = 0.06
                let z2 = i == 0 ? -z-s : -z+s
                let z3 = i == 0 ? 0-s : 0+s
                textNode.position = SCNVector3(x: 0, y: 0.5, z: numStr == "" ? z3 : z2)
         
                
                parent.addChildNode(textNode)
                textNode.name = parent.name
            }
            
        } else {
            textNode.scale = SCNVector3(x: scale*b, y: scale*b, z: 0.5)
            
            textNode.eulerAngles = SCNVector3(x: -a, y: 0, z: 0)
            textNode.position = SCNVector3(x: 0, y: 0.5, z: numStr == "" ? 0 : -z)
            
            parent.addChildNode(textNode)
            textNode.name = parent.name
        }
         
        
        // 0.000838223
        // 0.00029677112
        
        
   
        
        
        // numStr
        let text_2 = SCNText(string: numStr, extrusionDepth: 0.5)
        
        text_2.font = UIFont(name: "HiraginoSans-W6", size: 100); //.systemFont(ofSize: 10)
        text_2.firstMaterial?.diffuse.contents = color
        text_2.firstMaterial?.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        let textNode_2 = SCNNode(geometry: text_2)
        text_2.firstMaterial?.isDoubleSided = true
        
        let (min_2, max_2) = (textNode_2.boundingBox)
        let w_2 = Float(max_2.x - min_2.x)
        let h_2 = Float(max_2.y - min_2.y)
        textNode_2.pivot = SCNMatrix4MakeTranslation(w_2/2 + min_2.x, h_2/2 + min_2.y, 0)
        
        
        let scale_2 = parent.boundingBox.max.y / textNode_2.boundingBox.max.y
        
        
        textNode_2.scale = SCNVector3(x: scale_2*b_2, y: scale_2*b_2, z: 1)
        
        
        
        textNode_2.eulerAngles = SCNVector3(x: -a, y: 0, z: 0)
        textNode_2.position = SCNVector3(x: 0, y: 0.5, z: numStr == "" ? 0 : z)
        
        
        parent.addChildNode(textNode_2)
        
        textNode_2.name = parent.name
        
        
        
        
    }
    
    
    func makeSlices() {
        generatedSlices.removeAll()
        for i in 0..<itemsForVolume.count {
            let item = itemsForVolume[i]
            //            print(item.catIndex)
            //            item.count! = 0
            if item.count == nil {
                item.count = 0
            }
            for j in 0..<item.count! {
                let delay = 0.1 //遅延
                DispatchQueue.main.asyncAfter(deadline: .now() + delay*Double(j)) {
                    makeSliceFor(node: boxes[i], index: i, count: j+1)
                }
            }
        }
        
    }
    
    
    //    private let sliceLength: CGFloat = 1.0
    @State var scene = SCNScene()
    //    @State var slice = SCNNode()
    @State var slices = [SCNNode]()
    @State var generatedSlices = [SCNNode]()
    
    func makeSliceFor(node: SCNNode, index: Int, count: Int) {
        //        if let s = scene.rootNode.childNode(withName: "slice", recursively: true) {
        //            slice = s
        //        }
        //        slice.isHidden = false
        let c = slices[index].clone()
        c.name = slices[index].name
        c.scale.y = Float(sliceH)
        
        generatedSlices.append(c)
        
        c.geometry!.firstMaterial!.diffuse.contents = UIColor(colors[itemsForVolume[index].catIndex])
        
        
        scene.rootNode.addChildNode(c)
        c.isHidden = false
        let y = Float(node.position.y+5.0+(Float(itemsForVolume[index].count!)*Float(sliceH)))
        c.position = SCNVector3(node.position.x, y, node.position.z)
        
        
        let box = SCNBox(width: 1, height: sliceH+spaceV, length: 1, chamferRadius: 0)
        
        c.physicsBody = .init(type: .dynamic, shape: .init(geometry: box))
        
        //        c.physicsBody?.angularDamping = 0.5
        c.physicsBody?.damping = 0.9
        //        c.physicsBody?.rollingFriction = 0.5
        c.physicsBody?.friction = 0.1
        c.physicsBody?.restitution = 1
        c.physicsBody?.angularVelocityFactor = SCNVector3(x: 0, y: 0, z: 0) //
        
        //        let numStr = String(itemsForVolume[index].count!)
        let numStr = String(count)
     
        makeText(parent: c, str: itemsForVolume[index].title, numStr: numStr, color: UIColor(colors[itemsForVolume[index].catIndex]))
    }
    
    func getIndex(node: SCNNode) -> Int {
        var index = 0
        for i in 0..<itemsForVolume.count {
            if slices[i].name!.last == node.name!.last {
                index = i
            }
        }
        //        print(itemsForVolume[index].count!)
        return index
    }
    
    
    @State var offset : Float = 1 //0.5 + 0.1 // 1
    let k : Float = 1.5 // 互いの近さ
    let sliceH : CGFloat = 0.03
    let spaceV : CGFloat = 0.01 // 隙間
    
    @Query private var items: [Item]
    
    @State var itemsForVolume : [Item] = []
    
    func filteredItems() -> [Item] {
        return items.compactMap { item in
//            return (item.stepNumber == 1 && !item.continuing) ? item : nil
            return (item.inImmersion != nil && item.inImmersion! && !item.continuing) ? item : nil
        }
    }
    
    @State var box_0 : SCNNode = SCNNode()
    @State var box_1 : SCNNode = SCNNode()
    @State var box_2 : SCNNode = SCNNode()
    
    @State var text_0 : SCNText = SCNText()
    
    
    
    @State var countStr = ""
    @State var countStrColor = Color.red
    
    @State private var isLarge: Bool = false
    
    @State var opacity = 0.0
    @State var flg = false
    
    @State var tappedItem : Item? = nil
    

    @Environment(\.requestReview) var requestReview
    
    // レビュー依頼するか？
    
    
    func checkReview(count: Int) -> Bool {
        
//        return true
        return count == 5 || count == 30 || count == 55 || count == 80 || count == 100 || count%100 == 0

    }
    
    
    
    
    @Environment(\.scenePhase) private var scenePhase

    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
//                print("DragGesture.onChanged!!")

                

                
            }
            .onEnded { value in
//                print("DragGesture.onEnded!!")

            }
    }
    

    @State var allowCameraReset = false
    @State var allowControll = false
    
    @AppStorage(KeyString.camera_posX.rawValue) var camera_posX : Double = 0.0
    @AppStorage(KeyString.camera_posY.rawValue) var camera_posY : Double = 2.0
    @AppStorage(KeyString.camera_posZ.rawValue) var camera_posZ : Double = 5.0
    @AppStorage(KeyString.camera_rotX.rawValue) var camera_rotX : Double = -0.980085
    @AppStorage(KeyString.camera_rotY.rawValue) var camera_rotY : Double = -0.195142
    @AppStorage(KeyString.camera_rotZ.rawValue) var camera_rotZ : Double = 0.036788
    @AppStorage(KeyString.camera_rotW.rawValue) var camera_rotW : Double = 0.735900
    @AppStorage(KeyString.focalLength.rawValue) var focalLength : Double = 9.6
    @AppStorage(KeyString.fieldOfView.rawValue) var fieldOfView : Double = 55.0
    
    
    func resetCameraPos() {

        allowControll = false
        model.resetCameraScene()
        scene = model.scene_Immersion3D
        itemsForVolume = filteredItems()
        initLayout(scene: model.scene_Immersion3D)
        allowControll = true
        
        
    }
    
    
    func remakeScene3D() {
        allowControll = false
        model.resetScene()
        scene = model.scene_Immersion3D
        itemsForVolume = filteredItems()
        initLayout(scene: model.scene_Immersion3D)
        allowControll = true
    }
    
//    func generateParticle(scene: SCNScene) {
//        let emitterNode = SKEmitterNode(fileNamed: "SparkParticle")!
//        //作成したパーティクルのファイル名
////        let scene = SKScene(size: size)
////        scene.backgroundColor = .clear
////        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) 中央にパーティクルを配置
//        
//        scene.rootNode.addChildNode(emitterNode)
//        
////        scene.  addChild(emitterNode)
//        
//    }
//    
    /* ----------------------------------------------------------------------------
     MARK: - effect
     ------------------------------------------------------------------------------*/
//    func setRealPosition(node: SCNNode) {
//        let realPosition = node.presentation.worldPosition
//        node.position = realPosition
//        node.rotation = node.presentation.rotation
//    }
    
    func consumeEffect(node: SCNNode, pos: CGPoint) {
//    func consumeEffect() {

        let ps = scene.rootNode.childNode(withName: "particles", recursively: true)
        let p = ps?.particleSystems?.first
      
        
        let particleNode = SCNNode()
//        setRealPosition(node: particleNode)
//        particleNode.position = selectedNode.position
        particleNode.addParticleSystem(p!)
        
//        removeSelection(node: selectedNode)
//        selectedNode = nil
        
        let remove = SCNAction.removeFromParentNode()
//        let s1 = SCNAction.scale(to: 1.1, duration: 0.1)
//        let s2 = SCNAction.scale(to: 1, duration: 0.1)
//        
//
//        let seq = SCNAction.sequence([s1, s2])
//        node.runAction(seq)
//        
        
//        scene.rootNode.addChildNode(particleNode)
        
        particleNode.position = SCNVector3(0, 0.1, 0)
//        print("particleNode.rotation")

//        particleNode.rotation = SCNVector4(90, 0, 0, -90)
//        particleNode.eulerAngles.x = -90
//        particleNode.eulerAngles.y = 0
//        particleNode.eulerAngles.z = 0
        
        let a = Float(Double.pi/2.0)
        particleNode.eulerAngles = SCNVector3(x: -a, y: 0, z: 0)
//        print(particleNode.rotation)
        node.addChildNode(particleNode)
//        scene.rootNode.addChildNode(particleNode)
        
        let wait = SCNAction.wait(duration: 0.4)
        let seq2 = SCNAction.sequence([wait, remove])
        particleNode.runAction(seq2)
        
        
        
        //        let emitter1 = SCNParticleSystem(named: "Rain.scnp", inDirectory: "")
        //        let emitter2 = SCNParticleSystem(named: "Splash.scnp", inDirectory: "")
        //        emitter2?.loops = false
        //
        //        let particleNode = SCNNode()
        //        particleNode.position = SCNVector3(0,30,0)
        //        particleNode.addParticleSystem(emitter1!)
        //
        //        emitter1?.colliderNodes = [floorNode]
        //        emitter1?.particleDiesOnCollision = true
        //
        //        emitter1?.systemSpawnedOnCollision = emitter2
        //
        //        scene.rootNode.addChildNode(particleNode)
        
        
        
    }
    
    @State var showReview = false
    
    @State var showBenefitImage = false
    @State var selectedBenefitImage : UIImage = UIImage()

    
    
    var body: some View {
        
            VStack {
                
                switch selectedViewPicker {
     
                case 0:
                    
                    ZStack {
                        SceneView(scene: model.scene_Immersion3D,
                                  options: allowControll ? [.allowsCameraControl, .autoenablesDefaultLighting] : [.autoenablesDefaultLighting],
                                    
                                  delegate: model.renderDelegate)
                        
                        
//                            .gesture(drag)
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { notification in
                                print("--------didBecomeActiveNotification--------")
                                print("アクティブになった。")
                                print("--------didBecomeActiveNotification--------")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { notification in
                                print("--------willResignActiveNotification--------")
                                print("非活性になるよ。")
                                print("--------willResignActiveNotification--------")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { notification in
                                print("--------didEnterBackgroundNotification--------")
                                print("バックグランドになった。")
                                print("--------didEnterBackgroundNotification--------")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { notification in
                                print("--------willEnterForegroundNotification--------")
                                print("フォアグラウンドになるよ。")
                                print("--------willEnterForegroundNotification--------")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { notification in
                                print("--------willTerminateNotification--------")
                                print("アプリ終了するよ。")
                                print("--------willTerminateNotification--------")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                                print("--------UIDevice.orientationDidChangeNotification--------")
                                print("画面が回転したよ")
                                print("--------UIDevice.orientationDidChangeNotification--------")
                            }
                        
                        
                            .onAppear {
                                offset = 1/k
//                                scene = model.scene_Immersion3D
//                                itemsForVolume = filteredItems()
//                                initLayout(scene: model.scene_Immersion3D)
                                print("--------onAppear--------")
                                print("onAppear")
                                print("--------onAppear--------")
//                                allowCameraReset = true

                                remakeScene3D()
                                
                            }
                            .onWillAppear {
                                print("--------onWillAppear--------")
                                print("onWillAppear")
                                print("--------onWillAppear--------")
                                if allowCameraReset {
//                                    remakeScene3D()
//                                    allowControll = false
//                                    model.resetScene()
//                                    scene = model.scene_Immersion3D
//                                    itemsForVolume = filteredItems()
//                                    initLayout(scene: model.scene_Immersion3D)
//                                    allowControll = true
                                }
                            }
                            .onWillDisappear {
//                                allowControll = false
                                print("--------onWillDisappear--------")
                                print("onWillDisappear")
                                print("--------onWillDisappear--------")
                                print(allowControll)
                            }
                            .onChange(of: scenePhase, {
                                allowControll = true
                                allowCameraReset = true
                                
//                                remakeScene3D()
//                                print("scenePhase!")
//                                print(scenePhase)
                                let delay = 1.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                             
//                                    allowControll = true
//                                    allowCameraReset = true
//                                    print("allowControll!")
//                                    print(allowControll)
//                                    print("scenePhase!")
//                                    print(scenePhase)
                                }
                              
                            })
                            .alert("よろしければ、アプリの評価をしていただけませんか。", isPresented: $showReview) {
                                
                                Button("また今度", role: .none) {
                                    //                                    editingWant.title = textWant
                                }
                                //
                                Button("評価する", role: .cancel) {
                                    requestReview()
                          
                                }
                                //                                    Button("削除") {
                                //                                        deleteWant(editingWant)
                                //                                        isAlertPresented_Want = false
                                //                                    }
                           
                                
                            } message: {
                                // アラートのメッセージ...
                            
                                VStack {
                                    Text("\n制作の励みになります。\nよろしくお願いいたします。")
//                                    Image(systemName: "figure")
//                                        .resizable()
//                                        .frame(height: 10)
                                }
                           
                            }
                        
                        
//                            .alert("編集", isPresented: $isAlertPresented_Want) {
//                                TextField(isWant ? "やりたいこと": "やりたくないこと", text: $textWant)
//                                
//                                Button("削除", role: .destructive) {
//                                    deleteWant(editingWant)
//                                    isAlertPresented_Want = false
//                                }
//                                //                                    Button("削除") {
//                                //                                        deleteWant(editingWant)
//                                //                                        isAlertPresented_Want = false
//                                //                                    }
//                                //
//                                Button("キャンセル") {}
//                                Button("保存", role: .cancel) {
//                                    editingWant.title = textWant
//                                }
//                                
//                            } message: {
//                                // アラートのメッセージ...
//                                //                                        Text("必要な情報を入力してください")
//                            }
//                        
                        
//                            .alert(isPresented: @showReview) {
//                                
//                                
//                            }
//                        
                  
//
                        
                            .onDisappear{
                                print("--------onDisappear--------")
                                print("onDisappear")
                                print("--------onDisappear--------")

                                for g in generatedSlices {
                                    g.removeFromParentNode()
                                }
                            }
                            .gesture(
                                SpatialTapGesture(count: 1)
                                    .onEnded(){ event in
                                        
                                        guard let renderer = model.renderDelegate.lastRenderer else { return }
                                        let hits = renderer.hitTest(event.location, options: nil)
                                        if let tappedNode = hits.first?.node {
                                            
                                            let index = getIndex(node: tappedNode)

                                        
                                            
                                            itemsForVolume[index].count? += 1
                                         
                                            
                                            vivrate()
                                            
                                            consumeEffect(node: tappedNode,pos: event.location)
                                            
                                            //
                                            if let c = itemsForVolume[index].count {
                                                showReview = checkReview(count: c)
                                                makeSliceFor(node: boxes[index], index: index, count: c)
                                            }
                                                    
                                            
                                            if itemsForVolume[index].todayCount == nil {
                                                itemsForVolume[index].todayCount = 0
                                            }
                                            
                                            // 日付が変わったかチェック
                                            if countUpdateDateStr != dateToString(date: Date(), format: dateFormatStr) {
                                                resetItemsCount(items: itemsForVolume)
                                            }
                                            
                                            itemsForVolume[index].todayCount! += 1
                                            saveCountUpdateDateStr()
                                            
                        
                                            
                                            countStr = String(itemsForVolume[index].count!)
                                            countStrColor = colors[itemsForVolume[index].catIndex]
                                            
                                            tappedItem = itemsForVolume[index]
                                            
                                            isLarge = true
                                            flg = true
                                            
                                            withAnimation {
                                                opacity = 1
                                            }
                                            
                                            let delay = 0.5
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                                                buildObj(obj)
                                                isLarge = false
                                                flg = false
                                                
                                                withAnimation {
                                                    opacity = 0
                                                }
                                                
                                                
                                            }
                                            
                                            
                                        } else {
                                            // 画面タップ
                                            resetCameraPos()
                                            
                               
                                           
                                            
                                        }
                                        
                                    }
                            )
                        
                        VStack(spacing: 0) {
                            
                            
                            Text(tappedItem?.title ?? "")
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
//                                .stroke(color: .white, width: opacity == 0 ? 0 : 0.2)
                                .offset(y: 30)
                            
                            Text(countStr)
                                .font(.system(size: 140))
                                .foregroundStyle(countStrColor)
                                .stroke(color: .white, width: opacity == 0 ? 0 : 1.5)
                            
                            
                            
                       
//
                        }
                        .padding(.horizontal, 3)
  
//                        .background(.white.opacity(0.1)).cornerRadius(1)
                        .offset(x: 50, y: 150)
                        .scaleEffect(isLarge ? 1 : 0.1)
                        .animation(.spring(), value: isLarge)
                        .opacity(opacity)
                        
                        
                    }
                    .frame(alignment: .top)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(0)
                    
                case 1:
                    TaskView(items: filteredItems())
                        .tag(1)
                    
                case 2:
                    ImmersionScreen(showBenefitImage: $showBenefitImage, selectedBenefitImage: $selectedBenefitImage)
                        .tag(2)
                    
              
                                        
                default:
                    Text("")
                }
                
                HStack {
                    Picker("", selection: Binding(get: {
                        withAnimation {
                            selectedViewPicker
                        }
                    }, set: { (newVal) in
                        allowControll = newVal == 1 // 2D:true  3D:false
                        withAnimation {
                            selectedViewPicker = newVal
                        }
                    })) {
                        Text("3D")
                            .tag(0)
                        
                        Text("行動実績")
                            .tag(1)
              
                        Text("2D")
                            .tag(2)
                        
            
                        
                    }
                    .pickerStyle(.segmented)
                    .padding([.bottom, .horizontal])
                }
            }
            .animation(.easeIn, value: selectedViewPicker)
      
  
            
            

//        }
    }
}




//#Preview {
//    SceneScreen()
//}
