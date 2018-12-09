//
//  GameScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    
    var spaceShip = SKSpriteNode()
    let bulletSound = SKAction.playSoundFileNamed("bulletSound.m4a", waitForCompletion: false)
    
    
    
    var gameArea : CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio : CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func didMove(to view: SKView) {
        
        let background = spriteNode(imageName: "GamePlay_BG", valueName: "GamePlay_BG", positionZ: 0, positionX: self.size.width * 0.5, positionY: self.size.height * 0.5)
        
        self.addChild(background)
        
        spaceShip = spriteNode(imageName: "SpaceShip", valueName: "SpaceShip", positionZ: 2, positionX: self.size.width * 0.5, positionY: self.size.height * 0.2)
        spaceShip.setScale(0.85)
        self.addChild(spaceShip)
    }
    
    
    func fireBullet(){
        let bullet = spriteNode(imageName: "Bullet", valueName: "Bullet", positionZ: 1, positionX: spaceShip.position.x, positionY: spaceShip.position.y)
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSquence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        bullet.run(bulletSquence)
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            spaceShip.position.x += amountDragged
            
            if spaceShip.position.x > gameArea.maxX - (spaceShip.size.width / 2){
                spaceShip.position.x = gameArea.maxX - (spaceShip.size.width / 2)
            }
            
            if spaceShip.position.x < gameArea.minX + (spaceShip.size.width / 2){
                spaceShip.position.x = gameArea.minX + (spaceShip.size.width / 2)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            fireBullet()
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let nameOfTappedNode = tappedNode.name
            
            if nameOfTappedNode == "endScaneLabel"{
                
                tappedNode.name = ""
                tappedNode.removeAllActions()
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    let sceneMovement = EndScene(size: self.size)
                    sceneMovement.scaleMode = self.scaleMode
                    
                    let sceneTransition = SKTransition.fade(withDuration: 0.5)
                        
                        //SKTransition.reveal(with: SKTransitionDirection.left, duration: 0.5)
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
        }
        
    }
}
