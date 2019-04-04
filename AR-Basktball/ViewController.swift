//
//  ViewController.swift
//  AR-Basktball
//
//  Created by Gagandeep Mishra on 04/04/19.
//  Copyright © 2019 Gagandeep Mishra. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

   
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() // Modified as per requirement
        
        // Set the scene to the view
        sceneView.scene = scene
        addBackboard()
        registerGestureRecognizer()
    }
    func addBackboard()
    {
        guard let backBoardSecen = SCNScene(named: "art.scnassets/hoop.scn") else{
            return
        }
        guard let backBoardNode = backBoardSecen.rootNode.childNode(withName: "backboard", recursively: false) else
     {
        return
        }
        backBoardNode.position = SCNVector3(x: 0, y: 0.5, z: -3)
        sceneView.scene.rootNode.addChildNode(backBoardNode)
    }
    func registerGestureRecognizer()
    {
        let tap =  UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        // secen view to be accessed
        // access the point of view of the secen view.. the center view
        guard let seceneView = sender.view as? ARSCNView else{
            return
        }
        guard let centerPoint = seceneView.pointOfView else
        {
            return
        }
        //transform matrix
        // the orientation
        // the location of the camera
        // we need the orientation and location to determine the position of camera and its's at this point in which we want the ball to be placed
        
        let cameraTransform = centerPoint.transform
        let cameraLocation = SCNVector3(x:cameraTransform.m41,y:cameraTransform.m42,z:cameraTransform.m43)
        let cameraOrientation = SCNVector3(x:-cameraTransform.m31,y:-cameraTransform.m32,z:-cameraTransform.m33)
        // x1+x2 ,y1+y2,z1+z2
        let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y, cameraLocation.z + cameraOrientation.z)
        
        let ball = SCNSphere(radius: 0.15)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "basketballSkin.png")
        ball.materials = [material]
        let ballNode = SCNNode(geometry: ball)
        ballNode.position = cameraPosition
        seceneView.scene.rootNode.addChildNode(ballNode)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
