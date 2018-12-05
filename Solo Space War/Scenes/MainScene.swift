//
//  MainScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

class MainScene: SKScene{
    override func didMove(to view: SKView) {
        
        
        let backgroundImage = spriteNode(imageName: "GamePlay_BG_Blur", valueName: "backgroundBluur", positionZ: 0, positionX: Device.screenWidth * 0.5, positionY: Device.screenHeight * 0.5)
        self.addChild(backgroundImage)
        
        let gameLogo = spriteNode(imageName: "SpaceWarLogo", valueName: "spaceWarLogo", positionZ: 1, positionX: Device.screenWidth * 0.5, positionY: Device.screenHeight * 0.75)
        gameLogo.setScale(0.5)
        self.addChild(gameLogo)


        let startButton = spriteNode(imageName: "StartButton", valueName: "startButton", positionZ: 1, positionX: Device.screenWidth * 0.5, positionY: Device.screenHeight * 0.5)
        startButton.setScale(0.5)
        self.addChild(startButton)

        let earth = spriteNode(imageName: "Earth_Blur", valueName: "earth", positionZ: 1, positionX: Device.screenWidth * 0.5, positionY: Device.screenHeight * 0.1)
        earth.setScale(0.65)
        self.addChild(earth)
        
        let moon = spriteNode(imageName: "Moon_Blur", valueName: "moon", positionZ: 1, positionX: Device.screenWidth * 0.8, positionY: Device.screenHeight * 0.6)
        moon.setScale(0.65)
        self.addChild(moon)
        
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
                    
                    let sceneTransition = SKTransition.reveal(with: SKTransitionDirection.left, duration: 0.5)
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
        }
        
    }
}
