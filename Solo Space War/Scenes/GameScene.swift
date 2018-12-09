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
    
    
    
    
    //oyun alanı oluşturuldu.
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
        
        
        spawnObjectLevel()
    }
    
    
    //uzay mekiğine mermi eklendi
    func fireBullet(){
        let bullet = spriteNode(imageName: "Bullet", valueName: "Bullet", positionZ: 1, positionX: spaceShip.position.x, positionY: spaceShip.position.y)
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSquence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        bullet.run(bulletSquence)
    }
    
    //uzayda yok edilmesi gereken nesneler ve sağlık kazanmak amacıyla kurtarılması gereken astronot
    func spawnSpaceObject(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        
        let spawnObject = spriteNode(imageName: "SpawnObject6", valueName: "SpawnObject", positionZ: 2, positionX: startPoint.x, positionY: startPoint.y)
        self.addChild(spawnObject)
        
        let moveSpawnObject = SKAction.move(to: endPoint, duration: 1.5)
        let deleteSpawnObject = SKAction.removeFromParent()
        let spawnObjectSequence = SKAction.sequence([moveSpawnObject, deleteSpawnObject])
        
        spawnObject.run(spawnObjectSequence)
        
        
        let dX = endPoint.x - startPoint.x
        let dY = endPoint.y - startPoint.y
        let amountToRotate = atan2(dX, dY)
        spawnObject.zRotation = amountToRotate
        
        
    }
    
    //uzayda yok edilmesi gereken nesneler için zorluk seviyesi
    func spawnObjectLevel(){
        let spawn = SKAction.run(spawnSpaceObject)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawn,waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //uzay mekiğinin sahne üzerinde ki pozisyonları belirlendi.
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
        //spawnSpaceObject()
        
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
