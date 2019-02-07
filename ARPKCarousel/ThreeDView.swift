//
//  ThreeDView.swift
//  ARPKCarousel
//
//  Created by Gerald Kim on 7/2/19.
//  Copyright © 2019 ARPlaykit. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ThreeDView: SCNView {
    var isRotating: Bool = false
    var cameraNode: SCNNode?
    var modelNode: SCNNode?

    func loadWithUSDZ(arUrl: URL,
                      cameraPosition: SCNVector3,
                      cameraXRotation: Float,
                      pivotPosition: SCNVector3) throws {
        let scene = SCNScene()
        do {
            let rootScene = try? SCNScene(url: arUrl, options: nil)
            guard let modelScene = rootScene else { throw SceneError.invalidURL }
            modelNode = modelScene.rootNode
            modelNode?.pivot = SCNMatrix4MakeTranslation(pivotPosition.x,
                                                         pivotPosition.y,
                                                         pivotPosition.z)
            scene.rootNode.addChildNode(modelScene.rootNode)

            cameraNode = SCNNode()
            guard let cameraNode = cameraNode else { return }
            let camera = SCNCamera()
//            camera.usesOrthographicProjection = true
//            camera.orthographicScale = 9
//            camera.zNear = 0
            camera.zFar = 250
            cameraNode.camera = camera
            scene.rootNode.addChildNode(cameraNode)
            cameraNode.position = cameraPosition
            cameraNode.eulerAngles.x += cameraXRotation
//            cameraNode.look(at: (modelNode?.position)!)

            self.scene = scene
            setupDirectionalLighting()
            backgroundColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1.0)

            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 15)
            modelScene.rootNode.runAction(SCNAction.repeatForever(rotateAction))

            allowsCameraControl = false
        } catch {
            throw SceneError.cannotCreateScene
        }
    }

    func setupDirectionalLighting() {
        guard let scene = scene else {
            return
        }
        let environment = UIImage(named: "studio_small_03") //https://hdrihaven.com/
        scene.lightingEnvironment.contents = environment
        scene.lightingEnvironment.intensity = 2.0
    }
}

enum SceneError: Error, CustomDebugStringConvertible {
    case invalidURL
    case cannotCreateScene

    var debugDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .cannotCreateScene:
            return "Error in creating scene"
        }
    }
}
