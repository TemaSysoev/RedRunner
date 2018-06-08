//
//  GameScene.swift
//  Turbohead Shared
//
//  Created by Tema Sysoev on 01.06.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import SpriteKit
//import Cocoa//

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
    public var rocket = SKSpriteNode(imageNamed: "SpaceRocket.png")
    public var police = SKSpriteNode(imageNamed: "Police.png")
    public var earth = SKSpriteNode(imageNamed: "House.png")
    public var background1 = SKSpriteNode(imageNamed: "Background.png")
    public var background2 = SKSpriteNode(imageNamed: "Background.png")
    public var background3 = SKSpriteNode(imageNamed: "Background.png")
    public var background4 = SKSpriteNode(imageNamed: "Background.png")
    public var cam: SKCameraNode?

    public var deltaX = CGFloat(150)
    public var deltaY = CGFloat(300)
    public var oldDeltaX = CGFloat(0)
    public var oldDeltaY = CGFloat(0)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
   
    var pulse = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.1)
    var policeAction = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.01)
    var cameraLocateAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1)
    
    
    func rotaionAction(input: String){
        var k: CGFloat
        k = 1.0
        var rotateAction = SKAction.rotate(toAngle: rocket.zRotation, duration: 0.1)
        if input == "Up" {
            k = 0.25
            rotateAction = SKAction.rotate(toAngle: rocket.zRotation + 0.1, duration: 0.01)
        }
        if input == "Down" {
            k = 0.25
           rotateAction = SKAction.rotate(toAngle: rocket.zRotation - 0.1, duration: 0.01)
        }
        if input == "1" {
            k = 2
            rocket.physicsBody?.angularVelocity = 0.0
        }
        if input == "0" {
            k = -2
            rocket.physicsBody?.angularVelocity = 0.0
        }
        pulse = SKAction.applyImpulse(CGVector(dx: k*cos(rocket.zRotation), dy: k * sin(rocket.zRotation)), duration: 0.01)
        rocket.physicsBody?.angularVelocity = 0.0
        rocket.run(rotateAction)
        rocket.run(pulse)
        
        police.zRotation = rocket.zRotation
        
        
        
    }
    
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
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        rocket.name = "Rocket"
        rocket.childNode(withName: "Rocket")
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        rocket.zPosition = 10.0
        rocket.xScale = 0.12
        rocket.yScale = 0.12
        
        rocket.physicsBody = SKPhysicsBody(texture: rocket.texture!, size: rocket.size)
        rocket.physicsBody?.isDynamic = true
        rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
        rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Meteor
        rocket.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Meteor
        rocket.shadowedBitMask = 0
        
        police.name = "Police"
        police.position = CGPoint(x: rocket.position.x - 400, y: rocket.position.y)
        police.zPosition = 10.0
        police.xScale = 0.7
        police.yScale = 0.7
        
        police.physicsBody = SKPhysicsBody(texture: police.texture!, size: police.size)
        police.physicsBody?.isDynamic = true
        police.physicsBody?.categoryBitMask = PhysicsCategory.Police
        police.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        police.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        police.shadowedBitMask = 0
        
        earth.name = "Earth"
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY)
        earth.zPosition = 10.0
        earth.xScale = 0.4
        earth.yScale = 0.4
        
        earth.physicsBody = SKPhysicsBody(texture: earth.texture!, size: earth.size)
        earth.physicsBody?.isDynamic = false
        earth.physicsBody?.categoryBitMask = PhysicsCategory.Earth
        earth.physicsBody?.contactTestBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        earth.physicsBody?.collisionBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Meteor
        earth.shadowedBitMask = 0
        
        
        background1.zPosition = 5.0
        background1.xScale = 3.0
        background1.yScale = 3.0
        
        background2.zPosition = 5.0
        background2.xScale = 3.0
        background2.yScale = 3.0
        
        background3.zPosition = 5.0
        background3.xScale = 3.0
        background3.yScale = 3.0
        
        background4.zPosition = 5.0
        background4.xScale = 3.0
        background4.yScale = 3.0
        
        cam = SKCameraNode()
        self.camera = cam
        
       // self.addChild(background1)
       // self.addChild(background2)
       // self.addChild(background3)
        //self.addChild(background4)
        self.addChild(cam!)
        self.addChild(rocket)
        self.addChild(police)
        self.addChild(earth)
        
        /*
        //Площадь
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY - 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY + 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 150, y: self.frame.midY + 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 150, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY + 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 450, y: self.frame.midY + 300)
    
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 300, y: self.frame.midY + 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 150, y: self.frame.midY + 300)
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 450, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 300, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX - 150, y: self.frame.midY - 300)
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 300, y: self.frame.midY + 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 300, y: self.frame.midY - 300)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 300, y: self.frame.midY - 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 300, y: self.frame.midY + 150)
        //Выезд с площади
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 450, y: self.frame.midY - 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 450, y: self.frame.midY + 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 600, y: self.frame.midY - 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 600, y: self.frame.midY + 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 750, y: self.frame.midY - 150)
        
        self.addChild(earth.copy() as! SKNode)
        earth.position = CGPoint(x: self.frame.midX + 750, y: self.frame.midY + 150)
        */
        var xPos = -6000
        var yPos = 6000
        for _ in 1...10000 {
        
            var random = arc4random_uniform(3)
            if random == 0 {
                print(random)
                self.addChild(earth.copy() as! SKNode)
                 earth.texture = SKTexture(imageNamed: "House.png")
                earth.physicsBody?.isDynamic = false
                earth.position = CGPoint(x: xPos,y: yPos)
            }else{print(random)}
            if random == 1 {
                print(random)
                self.addChild(earth.copy() as! SKNode)
                earth.texture = SKTexture(imageNamed: "Stop.png")
                earth.physicsBody?.isDynamic = true
                earth.position = CGPoint(x: xPos,y: yPos)
            }else{print(random)}
            xPos = xPos + 150
            if xPos > 6000 {
                xPos = -6000
                yPos = yPos - 150
            }
        }
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
        background1.position = CGPoint(x: rocket.position.x + 250, y: rocket.position.y + 250)
        background2.position = CGPoint(x: rocket.position.x - 250, y: rocket.position.y + 500)
        background3.position = CGPoint(x: rocket.position.x - 250, y: rocket.position.y - 250)
        background4.position = CGPoint(x: rocket.position.x + 250, y: rocket.position.y - 250)
        
        cam?.position = rocket.position
       //cam?.zRotation = rocket.zRotation
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if t.location(in: self.scene!).x - t.previousLocation(in: self.scene!).x < 0.0 {
                rotaionAction(input: "Up")
            }
            if t.location(in: self.scene!).x - t.previousLocation(in: self.scene!).x > 0.0 {
                rotaionAction(input: "Down")
            }
            if t.location(in: self.scene!).y - t.previousLocation(in: self.scene!).y > 0.0 {
                 rotaionAction(input: "1")
            }
            if t.location(in: self.scene!).y - t.previousLocation(in: self.scene!).y < 0.0 {
                rotaionAction(input: "0")
            }
           
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
           
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
                rotaionAction(input: "Up")
            }
        
            if codeUnit == 115  {
                 rotaionAction(input: "0")
                
            }
            if codeUnit == 100 {
                 rotaionAction(input: "Down")
                
                //actionY = actionY - 5
            }
            
            if codeUnit == 119 {
                rotaionAction(input: "1")
                
            }
            policeAction = SKAction.applyImpulse(CGVector(dx: (rocket.position.x - police.position.x)/100, dy: (rocket.position.y - police.position.y)/100), duration: 1.0)
            police.physicsBody?.angularVelocity = 0.0
            police.run(policeAction)
            //self.addChild(police.copy() as! SKNode)
           
           
            
            
        }
    }
    override func mouseDown(with event: NSEvent) {
        print(position)
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

