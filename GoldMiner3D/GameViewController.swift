//
//  GameViewController.swift
//  GoldMiner3D
//
//  Created by Rachaus on 11/11/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var claw: SCNNode?
    var movementAction: SCNAction!
    
    let movementKey = "movement"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        let scnView = self.view as! SCNView
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        
        claw = scene.rootNode.childNode(withName: "Claw", recursively: false)
        
        let action = SCNAction.move(by: SCNVector3(0, 0, -4), duration: 1)
        let reverse = action.reversed()
        let initialPosition = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 1)
        let sequence = SCNAction.sequence([action, initialPosition, reverse, initialPosition])
        movementAction = SCNAction.repeatForever(sequence)

        claw?.runAction(movementAction, forKey: movementKey)
        
        scene.physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let _ = touches.first!
        
        claw?.removeAction(forKey: movementKey)
        claw?.runAction(SCNAction.move(by: SCNVector3(0, -10, 0), duration: 1))
        claw?.runAction(SCNAction.move(by: SCNVector3(0, 0, 0), duration: 1))
    }
    
}

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        let name = nodeA.name!
        
        if nodeB.name == "Claw" {
            nodeB.removeAllActions()
            nodeB.addChildNode(nodeA)
            
            let action = SCNAction.move(to: SCNVector3(nodeB.position.x, 0, nodeB.position.z), duration: 2)
            let block = SCNAction.run { (node) in
                let object = node.childNode(withName: name, recursively: false)
                object?.removeFromParentNode()
            }
            
            let sequence = SCNAction.sequence([action, block])
            
            nodeB.runAction(sequence)
            nodeB.runAction(movementAction, forKey: movementKey)
        }
        else {
            nodeB.removeAllActions()
            nodeB.addChildNode(nodeA)
            
            let action = SCNAction.move(to: SCNVector3(nodeB.position.x, 0, nodeB.position.z), duration: 2)
            let block = SCNAction.run { (node) in
                let object = node.childNode(withName: name, recursively: false)
                object?.removeFromParentNode()
            }
            
            let sequence = SCNAction.sequence([action, block])
            
            nodeB.runAction(sequence)
            nodeB.runAction(movementAction, forKey: movementKey)
        }
    }
    
}
