//
//  Launcher.swift
//  Turbohead macOS
//
//  Created by Tema Sysoev on 06/04/2019.
//  Copyright © 2019 Tema Sysoev. All rights reserved.
//

import Foundation
import Cocoa

class LauncherViewController: NSViewController {
    
    var random = arc4random_uniform(100)
    @IBOutlet weak var genLabel: NSTextField!
    var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(LauncherViewController.updateTimer)), userInfo: nil, repeats: true)

    @IBAction func playAction(_ sender: Any) {
        genLabel.cell?.title = "Loading. Please wait"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...3600 {
           // Public.counter = Public.counter + 1
            random = arc4random_uniform(100)
            if random <= 20 {
                Public.mapCreator.append(1)
            } else {
                Public.mapCreator.append(0)
            }
            if (i == 1768) || (i == 1769) || (i == 1829) || (i == 1830) {
                Public.mapCreator.insert(0, at: i)
            }
        }
        updateTimer()
        
    }
    @objc func updateTimer(){
        genLabel.cell?.title = "Generating \(Public.counter) of 5000 objects"
    }
}
