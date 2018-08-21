//
//  GameScene.swift
//  Turbohead Shared
//
//  Created by Tema Sysoev on 01.06.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import SpriteKit
//import Cocoa

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Rocket   : UInt32 = 1      // 1
    static let Earth: UInt32 = 1 << 1
    static let Police: UInt32 = 1 << 2// 2
    static let Transport: UInt32 = 1 << 3
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

public var rocket = SKSpriteNode(imageNamed: "Rocket.png")
public var pirate1 = SKSpriteNode(imageNamed: "Police.png")
public var police2 = SKSpriteNode(imageNamed: "Police.png")
public var police3 = SKSpriteNode(imageNamed: "Police.png")
public var transport = SKSpriteNode(imageNamed: "Transport.png")
public var earth = SKSpriteNode(imageNamed: "House.png")
public var stop = SKSpriteNode(imageNamed: "Stop.png")
public var background1 = SKSpriteNode(imageNamed: "Background.png")
public var background2 = SKSpriteNode(imageNamed: "Background.png")
public var background3 = SKSpriteNode(imageNamed: "Background.png")
public var background4 = SKSpriteNode(imageNamed: "Background.png")
public var cam: SKCameraNode?

public var up = SKSpriteNode(imageNamed: "Up.png")
public var down = SKSpriteNode(imageNamed: "Down.png")
public var right = SKSpriteNode(imageNamed: "Right.png")
public var left = SKSpriteNode(imageNamed: "Left.png")

public var deltaX = CGFloat(150)
public var deltaY = CGFloat(300)
public var oldDeltaX = CGFloat(0)
public var oldDeltaY = CGFloat(0)



class GameScene: SKScene, SKPhysicsContactDelegate {
    
   
    var pulse = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.1)
    var policeAction = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.01)
    var policeAction2 = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.01)
    var policeAction3 = SKAction.applyImpulse(CGVector(dx: 0, dy: 0), duration: 0.01)
    var cameraLocateAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1)
    var crash = 100
    var label1 = SKLabelNode()
    
    func checkCrash() {
        crash = crash - 1
        label1.text = "❤️: \(crash)"
        if crash <= 0 {
            self.isPaused = true
            label1.text = "Oh, shit! Fucking cops had you"
        }
    }
    func rotaionAction(input: String){
        var k: CGFloat
        k = 1.0
        var rotateAction = SKAction.rotate(toAngle: rocket.zRotation, duration: 0.1)
        if input == "Up" {
            
            k = 0.1
            rotateAction = SKAction.rotate(toAngle: rocket.zRotation + 0.1, duration: 0.005)
        }
        if input == "Down" {
            k = 0.1
           rotateAction = SKAction.rotate(toAngle: rocket.zRotation - 0.1, duration: 0.005)
        }
        if input == "1" {
            rocket.run(SKAction.animate(with: [SKTexture(imageNamed: "RocketRun.png")], timePerFrame: 0.02, resize: false, restore: true))
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
        pirate1.zRotation = rocket.zRotation
        police2.zRotation = rocket.zRotation
        police3.zRotation = rocket.zRotation
        
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
        
        transport.name = "Rocket"
        transport.childNode(withName: "Rocket")
        transport.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        transport.zPosition = 10.0
        transport.xScale = 0.65
        transport.yScale = 0.65
        
        transport.physicsBody = SKPhysicsBody(texture: transport.texture!, size: transport.size)
        transport.physicsBody?.isDynamic = true
        transport.physicsBody?.categoryBitMask = PhysicsCategory.Transport
        transport.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Rocket
        transport.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Rocket
        transport.shadowedBitMask = 0
    
        rocket.name = "Rocket"
        rocket.childNode(withName: "Rocket")
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        rocket.zPosition = 10.0
        rocket.xScale = 0.65
        rocket.yScale = 0.65
        
        rocket.physicsBody = SKPhysicsBody(texture: rocket.texture!, size: rocket.size)
        rocket.physicsBody?.isDynamic = true
        rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
        rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Transport
        rocket.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Police | PhysicsCategory.Transport
        rocket.shadowedBitMask = 0
        
        pirate1.name = "Police"
        pirate1.position = CGPoint(x: rocket.position.x - 400, y: rocket.position.y)
        pirate1.zPosition = 10.0
        pirate1.xScale = 0.9
        pirate1.yScale = 0.9
        
        pirate1.physicsBody = SKPhysicsBody(texture: pirate1.texture!, size: pirate1.size)
        pirate1.physicsBody?.isDynamic = true
        pirate1.physicsBody?.categoryBitMask = PhysicsCategory.Police
        pirate1.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        pirate1.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        pirate1.shadowedBitMask = 0
        
        police2.name = "Police"
        police2.zPosition = 10.0
        police2.xScale = 0.9
        police2.yScale = 0.9
        
        police2.physicsBody = SKPhysicsBody(texture: pirate1.texture!, size: pirate1.size)
        police2.physicsBody?.isDynamic = true
        police2.physicsBody?.categoryBitMask = PhysicsCategory.Police
        police2.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        police2.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        police2.shadowedBitMask = 0
        
        police3.name = "Police"
        police3.position = CGPoint(x: rocket.position.x - 400, y: rocket.position.y)
        police3.zPosition = 10.0
        police3.xScale = 0.9
        police3.yScale = 0.9
        
        police3.physicsBody = SKPhysicsBody(texture: pirate1.texture!, size: pirate1.size)
        police3.physicsBody?.isDynamic = true
        police3.physicsBody?.categoryBitMask = PhysicsCategory.Police
        police3.physicsBody?.contactTestBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        police3.physicsBody?.collisionBitMask = PhysicsCategory.Earth | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Police
        police3.shadowedBitMask = 0
        
        earth.name = "Earth"
        earth.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY)
        earth.zPosition = 10.0
        earth.xScale = 2.1
        earth.yScale = 2.1
        
        earth.physicsBody = SKPhysicsBody(texture: earth.texture!, size: earth.size)
        earth.physicsBody?.isDynamic = false
        earth.physicsBody?.categoryBitMask = PhysicsCategory.Earth
        earth.physicsBody?.contactTestBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Earth
        earth.physicsBody?.collisionBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Earth
        earth.shadowedBitMask = 0
        
        stop.name = "Stop"
        stop.position = CGPoint(x: self.frame.midX - 600, y: self.frame.midY)
        stop.zPosition = 9.0
        stop.xScale = 2.1
        stop.yScale = 2.1
        
        stop.physicsBody = SKPhysicsBody(texture: stop.texture!, size: stop.size)
        stop.physicsBody?.isDynamic = true
        stop.physicsBody?.categoryBitMask = PhysicsCategory.Transport
        stop.physicsBody?.contactTestBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Earth
        stop.physicsBody?.collisionBitMask = PhysicsCategory.Police | PhysicsCategory.Rocket | PhysicsCategory.Transport | PhysicsCategory.Earth
        stop.shadowedBitMask = 0
        
        
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
        
        label1.text = "❤️: \(crash)"
        label1.fontSize = 20
        label1.fontColor = SKColor.white
        label1.fontName = "Helveretica Bold"
        label1.zPosition = 30
        label1.position = CGPoint(x: rocket.position.x,  y: rocket.position.y + 200)
        label1.isHidden = false
        
        
        up.name = "Rocket"
        up.childNode(withName: "Up")
        up.position = CGPoint(x: rocket.position.x - 300, y: rocket.position.x - 200)
        up.zPosition = 30.0
        up.xScale = 0.65
        up.yScale = 0.65
        
        cam = SKCameraNode()
        self.camera = cam
    
        self.addChild(cam!)
        self.addChild(rocket)
        self.addChild(pirate1)
        self.addChild(transport)
        self.addChild(earth)
        self.addChild(stop)
        self.addChild(police2)
        self.addChild(police3)
        self.addChild(label1)
        
        var xPos = -6000
        var yPos = 6000
        var random = arc4random_uniform(100)
        var counter = 1
        for _ in 1...5000 {
            counter = counter + 1
           random = arc4random_uniform(100)
            if (xPos == Int(self.frame.midX)) && (yPos == Int(self.frame.midY)) || (xPos == Int(self.frame.midX - 400)) && (yPos == Int(self.frame.midY)){
                    random = 1
            }
            if random <= 5 {
                    self.addChild(earth.copy() as! SKNode)
                    earth.texture = SKTexture(imageNamed: "House.png")
                   // earth.physicsBody = SKPhysicsBody(texture: earth.texture!, size: earth.size)
                    earth.position = CGPoint(x: xPos,y: yPos)
            }
            
            xPos = xPos + 150
            if xPos > 6000 {
                xPos = -6000
                yPos = yPos - 150
            }
            
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        func rocketDidCollideWithPolice(rocket:SKSpriteNode, police:SKSpriteNode) {
            checkCrash()
        }
        func rocketDidCollideWithPolice2(rocket:SKSpriteNode, police2:SKSpriteNode) {
            checkCrash()
        }
        func rocketDidCollideWithPolice3(rocket:SKSpriteNode, police3:SKSpriteNode) {
            checkCrash()
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Rocket != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Police != 0)) {
            rocketDidCollideWithPolice(rocket: firstBody.node as! SKSpriteNode, police: secondBody.node as! SKSpriteNode)
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Rocket != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Police != 0)) {
            rocketDidCollideWithPolice2(rocket: firstBody.node as! SKSpriteNode, police2: secondBody.node as! SKSpriteNode)
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Rocket != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Police != 0)) {
            rocketDidCollideWithPolice3(rocket: firstBody.node as! SKSpriteNode, police3: secondBody.node as! SKSpriteNode)
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
        
        label1.position = CGPoint(x: rocket.position.x,  y: rocket.position.y + 200)
        cam?.position = rocket.position
       //cam?.zRotation = rocket.zRotation
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

        
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if iOSControl.turnRight == true {
            rotaionAction(input: "Down")
        }
        
        for t in touches {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
           
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
            policeAction = SKAction.applyImpulse(CGVector(dx: (transport.position.x - pirate1.position.x)/100, dy: (transport.position.y - pirate1.position.y)/100), duration: 1.0)
            pirate1.physicsBody?.angularVelocity = 0.0
            pirate1.run(policeAction)
            
            policeAction2 = SKAction.applyImpulse(CGVector(dx: (transport.position.x - police2.position.x)/100, dy: (transport.position.y - police2.position.y)/100), duration: 1.0)
            police2.physicsBody?.angularVelocity = 0.0
            police2.run(policeAction2)
            
            policeAction3 = SKAction.applyImpulse(CGVector(dx: (transport.position.x - police3.position.x)/100, dy: (transport.position.y - police3.position.y)/100), duration: 1.0)
            police3.physicsBody?.angularVelocity = 0.0
            police3.run(policeAction3)
            
            pirate1.run(SKAction.animate(with: [SKTexture(imageNamed: "PoliceRun.png")], timePerFrame: 0.02, resize: false, restore: true))
            police2.run(SKAction.animate(with: [SKTexture(imageNamed: "PoliceRun.png")], timePerFrame: 0.02, resize: false, restore: true))
            police3.run(SKAction.animate(with: [SKTexture(imageNamed: "PoliceRun.png")], timePerFrame: 0.02, resize: false, restore: true))
            
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

