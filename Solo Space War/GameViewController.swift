//
//  GameViewController.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Device.deviceModel)
        print("screen width  : \(Device.screenWidth)")
        print("screen height : \(Device.screenHeight)")
        
        let scene = GameScene(size: CGSize(width: 1357, height: 2410))

        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        skView.ignoresSiblingOrder = false
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
