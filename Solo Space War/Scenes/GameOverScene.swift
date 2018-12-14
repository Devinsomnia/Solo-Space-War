//
//  EndScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

var highScore = Int()

class GameOverScene: SKScene{
    
    var areaBlur = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.post(name: NSNotification.Name("showRewardVideo"), object: nil)
        
        let background = spriteNode(imageName: "GamePlay_BG", valueName: "GamePlay_BG", positionZ: 0, positionX: self.size.width * 0.5, positionY: self.size.height * 0.5)
        background.size = self.size
        self.addChild(background)
        
        areaBlur = spriteNode(imageName: "ddenek", valueName: "ddenek", positionZ: 1, positionX: self.size.width * 0.5, positionY: self.size.height * 0.5)
        areaBlur.setScale(0)
        self.addChild(areaBlur)
        //let scaleIn = SKAction.scale(to: 1, duration: 0.5)
        //areaBlur.run(scaleIn)
        
        
        
        
        let gameOverLabel = labelNode(fontName: "effra-heavy", fontText: "GAME OVER", fontSize: 200, fontColorBlendFactor: 1, fontColor: UIColor.color(redValue: 239, greenValue: 74, blueValue: 74, alpha: 1), fontXPoz: self.size.width * 0.5, fontYPoz: self.size.height * 0.65, fontZPoz: 1)
        //gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.setScale(0)
        self.addChild(gameOverLabel)
        
        
        let scoreLabel = labelNode(fontName: "effra-heavy", fontText: "SCORE: \(gameScore)", fontSize: 125, fontColorBlendFactor: 1, fontColor: UIColor.color(redValue: 149, greenValue: 199, blueValue: 64, alpha: 1), fontXPoz: self.size.width * 0.5, fontYPoz: self.size.height * 0.5 , fontZPoz: 1)
        scoreLabel.horizontalAlignmentMode = .center
        //scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.setScale(0)
        self.addChild(scoreLabel)
        
        
        
        let defaults = UserDefaults()
        highScore = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScore {
            highScore = gameScore
            defaults.set(highScore, forKey: "highScoreSaved")
            NotificationCenter.default.post(name: NSNotification.Name("GCSaveHighScore"), object: nil)
        }
        
        
        let highScoreLabel = labelNode(fontName: "effra-heavy", fontText: "HIGH SCORE: \(highScore)", fontSize: 125, fontColorBlendFactor: 1, fontColor: UIColor.color(redValue: 149, greenValue: 199, blueValue: 64, alpha: 1), fontXPoz: self.size.width * 0.5, fontYPoz: self.size.height * 0.43, fontZPoz: 1) // 140,199,64
        highScoreLabel.horizontalAlignmentMode = .center
        //highScoreLabel.verticalAlignmentMode = .top
        highScoreLabel.setScale(0)
        self.addChild(highScoreLabel)
        
        
        let restartLabel = labelNode(fontName: "theboldfont", fontText: "Restart", fontSize: 125, fontColorBlendFactor: 1, fontColor: UIColor.color(redValue: 228, greenValue: 228, blueValue: 288, alpha: 1), fontXPoz: self.size.width * 0.68, fontYPoz: self.size.height * 0.3, fontZPoz: 1)
        //restartLabel.horizontalAlignmentMode = .left
        restartLabel.name = "Restart"
        restartLabel.setScale(0)
        
        self.addChild(restartLabel)
        
        let mainSceneLabel = labelNode(fontName: "theboldfont", fontText: "Menu", fontSize: 125, fontColorBlendFactor: 1, fontColor: UIColor.color(redValue: 228, greenValue: 228, blueValue: 288, alpha: 1), fontXPoz: self.size.width * 0.28, fontYPoz: self.size.height * 0.3, fontZPoz: 1)
        //mainSceneLabel.horizontalAlignmentMode = .right
        mainSceneLabel.name = "Menu"
        mainSceneLabel.setScale(0)
        self.addChild(mainSceneLabel)
        
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.3)
        areaBlur.run(scaleIn)
        gameOverLabel.run(scaleIn)
        scoreLabel.run(scaleIn)
        highScoreLabel.run(scaleIn)
        restartLabel.run(scaleIn)
        mainSceneLabel.run(scaleIn)
        
        fadeIn()
//        let start = labelNode(fontName: "effra-heavy", fontText: "Go to Start Scene", fontSize: 100, fontColorBlendFactor: 1, fontColor: UIColor.white, fontXPoz: self.size.width / 2, fontYPoz: self.size.height / 2, fontZPoz: 1)
//        start.name = "startScene"
//        self.addChild(start)
    }
    
    func fadeIn(){
//        let scaleIn = SKAction.scale(to: 1, duration: 0.5)
//        areaBlur.run(scaleIn)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let nameOfTappedNode = tappedNode.name
            
            if nameOfTappedNode == "Restart"{
                
                tappedNode.name = ""
                tappedNode.removeAllActions()
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    let sceneMovement = GameScene(size: self.size)
                    sceneMovement.scaleMode = self.scaleMode
                    
                    let sceneTransition = SKTransition.fade(withDuration: 0.5)
        
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
            if nameOfTappedNode == "Menu"{
                
                tappedNode.name = ""
                tappedNode.removeAllActions()
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    let sceneMovement = MainScene(size: self.size)
                    sceneMovement.scaleMode = self.scaleMode
                    
                    let sceneTransition = SKTransition.fade(withDuration: 0.5)
                    
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
        }
        
    }
}
