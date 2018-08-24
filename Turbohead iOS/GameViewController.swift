//
//  GameViewController.swift
//  Turbohead iOS
//
//  Created by Tema Sysoev on 01.06.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct iOSControl {
    static var turnRight = false
    static var turnLeft = false
    static var turnUp = false
    static var turnBack = false
}
class GameViewController: UIViewController {
    
    
    @IBAction func rightChange(_ sender: Any) {
        iOSControl.turnRight = true
    }
    @IBAction func leftChange(_ sender: Any) {
        iOSControl.turnLeft = true
    }
    @IBAction func upChange(_ sender: Any) {
        iOSControl.turnUp = true
    }
    @IBAction func backChange(_ sender: Any) {
        iOSControl.turnBack = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)

        
        let scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    @objc func updateTimer(){
        missonTimer =- 1
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
