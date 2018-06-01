//
//  GameScene.swift
//  Turbohead Shared
//
//  Created by Tema Sysoev on 01.06.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import SpriteKit
import Cocoa

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Rocket   : UInt32 = 1      // 1
    static let Earth: UInt32 = 1 << 1
    static let Police: UInt32 = 1 << 2// 2
    static let Meteor: UInt32 = 1 << 3
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var rocket = SKSpriteNode(imageNamed: "Rocket.png")
    var police = SKSpriteNode(imageNamed: "Police.png")
    var earth = SKSpriteNode(imageNamed: "Earth.png")
    var cam: SKCameraNode?
    
    var actionX = 0.0
    var actionY = 0.0
    
    var pulse = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.1)
    var cameraLocateAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1)
    
    
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.01)
        
        
        rocket.name = "Rocket"
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        rocket.zPosition = 10.0
        rocket.xScale = 0.3
        rocket.yScale = 0.3
        
        rocket.physicsBody = SKPhysicsBody(texture: rocket.texture!, size: rocket.size)
        rocket.physicsBody?.isDynamic = true
        rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
        rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Meteor
        rocket.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Meteor
        rocket.shadowedBitMask = 0
        
        police.name = "Police"
        police.position = CGPoint(x: rocket.position.x - 400, y: rocket.position.y)
        police.zPosition = 10.0
        police.xScale = 0.3
        police.yScale = 0.3
        
        police.physicsBody = SKPhysicsBody(texture: police.texture!, size: police.size)
        police.physicsBody?.isDynamic = true
        police.physicsBody?.categoryBitMask = PhysicsCategory.Police
        police.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        police.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        police.shadowedBitMask = 0
        
        earth.name = "Earth"
        earth.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        earth.zPosition = 10.0
        earth.xScale = 2.0
        earth.yScale = 2.0
        
        earth.physicsBody = SKPhysicsBody(texture: earth.texture!, size: earth.size)
        earth.physicsBody?.isDynamic = false
        earth.physicsBody?.categoryBitMask = PhysicsCategory.Earth
        earth.physicsBody?.contactTestBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        earth.physicsBody?.collisionBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        earth.shadowedBitMask = 0
        
        cam = SKCameraNode()
        self.camera = cam
        
        self.addChild(cam!)
        self.addChild(rocket)
        self.addChild(police)
        self.addChild(earth)
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
      
        
        cam?.position = rocket.position
       // cam?.zRotation = rocket.zRotation
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
   
    override func keyDown(with event:NSEvent) {
        for codeUnit in event.characters!.utf16 {
            // 119 97 115 100
            if codeUnit == 97 {
                
                rocket.zRotation = rocket.zRotation + 0.1
                pulse = SKAction.applyImpulse(CGVector(dx: 10 * cos(rocket.zRotation), dy: 10 * sin(rocket.zRotation)), duration: 0.01)
                rocket.run(pulse)
            }
        
            if codeUnit == 115  {
                
                
            }
            if codeUnit == 100 {
                pulse = SKAction.applyImpulse(CGVector(dx: 10 * cos(rocket.zRotation), dy: 10 * sin(rocket.zRotation)), duration: 0.01)
                rocket.run(pulse)
                rocket.zRotation = rocket.zRotation - 0.1
                //actionY = actionY - 5
            }
            
            if codeUnit == 119 {
                rocket.physicsBody?.angularVelocity = 0.0
                
            }
            //rocket.physicsBody?.velocity = CGVector(dx: 1000 * cos(rocket.zRotation), dy: 1000 * sin(rocket.zRotation))
            //rocket.physicsBody?.velocity = CGVector(dx: actionX, dy: actionY)
           
            
            
        }
    }
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

