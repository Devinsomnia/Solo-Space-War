//
//  MainScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

class MainScene: SKScene{
    var Path = UIBezierPath()
    
    override func didMove(to view: SKView) {
        
        
        let backgroundImage = spriteNode(imageName: "GamePlay_BG_Blur", valueName: "backgroundBluur", positionZ: 0, positionX: self.size.width * 0.5, positionY: self.size.height * 0.5)
        self.addChild(backgroundImage)
        
        let gameLogo = spriteNode(imageName: "SpaceWarLogo", valueName: "spaceWarLogo", positionZ: 2, positionX: self.size.width * 0.5, positionY: self.size.height * 0.75)
        //gameLogo.setScale(0.5)
        self.addChild(gameLogo)


        let startButton = spriteNode(imageName: "StartButton", valueName: "startButton", positionZ: 2, positionX: self.size.width * 0.5, positionY: self.size.height * 0.55)
        //startButton.setScale(0.5)
        self.addChild(startButton)

        
        let optionsButton = spriteNode(imageName: "GameCenterButton", valueName: "GameCenterButton", positionZ: 2, positionX: self.size.width * 0.5, positionY: self.size.height * 0.45)
        //optionsButton.setScale(0.5)
        self.addChild(optionsButton)

        let quitButton = spriteNode(imageName: "QuitButton", valueName: "QuitButton", positionZ: 2, positionX: self.size.width * 0.5, positionY: self.size.height * 0.35)
        //quitButton.setScale(0.5)
        self.addChild(quitButton)

    
        let earth = spriteNode(imageName: "Earth_Blur", valueName: "earth", positionZ: 1, positionX: self.size.width * 0.5, positionY: self.size.height * -0.05)
        //earth.setScale(0.65)
        self.addChild(earth)
    
        let earthRotate = SKAction.rotate(byAngle: 360, duration: 10000)
        earth.run(SKAction.repeatForever(earthRotate))
        
        
        
        let moon = spriteNode(imageName: "Moon_Blur", valueName: "moon", positionZ: 1, positionX: self.size.width * 0.6, positionY: self.size.height * 0.6)
        //moon.setScale(0.65)
        self.addChild(moon)
    
        
        
        let dx = moon.position.x
        let dy = moon.position.y

        let radyan = atan2(dy, dx)

        Path = UIBezierPath(arcCenter: CGPoint(x: earth.position.x, y: earth.position.y), radius: 1200 , startAngle: radyan, endAngle: radyan + CGFloat(Double.pi * 4), clockwise: true)

        let follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 4)
        moon.run(SKAction.sequence([follow]))
        
        
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let nameOfTappedNode = tappedNode.name
        
            if nameOfTappedNode == "startButton"{
                
                tappedNode.name = ""
                tappedNode.removeAllActions()
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    let sceneMovement = GameScene(size: self.size)
                    sceneMovement.scaleMode = self.scaleMode
                    
                    let sceneTransition = SKTransition.fade(withDuration: 0.5)
                    
                        //SKTransition.reveal(with: SKTransitionDirection.left, duration: 0.5)
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
            if nameOfTappedNode == "GameCenterButton"{
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    NotificationCenter.default.post(name: NSNotification.Name("showLeaderBoard"), object: nil)
                })
                
                
            }
            
            if nameOfTappedNode == "QuitButton"{
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    exit(0)
                })
                
                
            }
            
        }
        
    }
}
