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
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Game Center Authantication login
        authPlayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showLeaderBoard), name: NSNotification.Name("showLeaderBoard"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.GCSaveHighScore), name: NSNotification.Name("GCSaveHighScore"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showGlobalSkore), name: NSNotification.Name(rawValue:"showGlobalScore"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.kaydetScoreGS), name: NSNotification.Name(rawValue:"GSKAYDET"), object: nil)
        
        
        print(Device.deviceModel)
        print("screen width  : \(Device.screenWidth)")
        print("screen height : \(Device.screenHeight)")
        
        let scene = GameOverScene(size: CGSize(width: 1357, height: 2410))

        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        skView.ignoresSiblingOrder = false
        
        scene.scaleMode = .fill
        
        skView.presentScene(scene)
    }
    
    
    // Game Center Save High Score
    func saveHighScore(number: Int){
        
        if GKLocalPlayer.local.isAuthenticated{
            
            let scoreReported = GKScore(leaderboardIdentifier: "SWSBestScore")
            scoreReported.value = Int64(number)
            let scoreArray: [GKScore] = [scoreReported]
            GKScore.report(scoreArray, withCompletionHandler: nil)

        }
    }
    
    @objc func GCSaveHighScore(){
        saveHighScore(number: highScore)
    }
    
    
    //Game Center Show Leader Board
    
    @objc func showLeaderBoard(){
        
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    //Game Center authantication
    func authPlayer(){
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil{
                self.present(viewController!, animated: true, completion: nil)
            }
            else{
                print((GKLocalPlayer.local.isAuthenticated))
            }
            
        }
        
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
