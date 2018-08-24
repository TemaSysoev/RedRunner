//
//  GameViewController.swift
//  Turbohead macOS
//
//  Created by Tema Sysoev on 01.06.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    @objc func updateTimer(){
        missonTimer -= 1
    }
}

