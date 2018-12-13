//
//  GameScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameScore = 0
    var gameScoreLabel = SKLabelNode()
    var gameScoreImages = SKSpriteNode()
    
    var randomObjectNumber = Int()
    
    var livesNumber = 3
    var livesLabel = SKLabelNode()
    var livesImage = SKSpriteNode()
    
    var tapToStartLabel = SKLabelNode()
    
    var levelNumber = 0
    
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    
    var spaceShip = SKSpriteNode()
    let bulletSound = SKAction.playSoundFileNamed("bulletSound.m4a", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSound2.m4a", waitForCompletion: false)
    
    
    
    enum GameState{
        case previosGame // when the game state is before the start of the game
        case inGame      // when the game state is during the game
        case afterGame   // when the game state is after the game
    }
    
    var currentGameState = GameState.previosGame
    
    
    
    struct  PhysicsCategories{
        static let None: UInt32 = 0
        static let SpaceShip: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10      //2
        static let SpaceObject: UInt32 = 0b100   //4
        
    }
    
    
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
        
        self.physicsWorld.contactDelegate = self
        
        
        for i in 0...1{
            let background = spriteNode(imageName: "GamePlay_BG", valueName: "Background", positionZ: 0, positionX: self.size.width * 0.5, positionY: self.size.height * CGFloat(i))
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
        
//            let background = SKSpriteNode(imageNamed: "GamePlay_BG")
//            background.name = "Background"
//            background.anchorPoint = CGPoint(x: 0.5, y: 0)
//            background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * CGFloat(i))
//            background.zPosition = 0
            
            self.addChild(background)
        
        }
        spaceShip = spriteNode(imageName: "SpaceShip", valueName: "SpaceShip", positionZ: 2, positionX: self.size.width * 0.5, positionY: -self.size.height - spaceShip.frame.size.height)
        spaceShip.setScale(0.85)
        
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody!.affectedByGravity = false
        spaceShip.physicsBody!.categoryBitMask = PhysicsCategories.SpaceShip
        spaceShip.physicsBody!.collisionBitMask = PhysicsCategories.None
        spaceShip.physicsBody!.contactTestBitMask = PhysicsCategories.SpaceObject
        self.addChild(spaceShip)
        

        
        //spawnObjectLevel()
        
        gameScoreImages = spriteNode(imageName: "Explosion", valueName: "Explosion", positionZ: 100, positionX: self.size.width * 0.14, positionY: self.size.height + gameScoreImages.frame.size.height) // self.size.height * 0.947
        gameScoreImages.zRotation = -30
        gameScoreImages.setScale(0.8)
        //self.addChild(gameScoreImages)
        
        
        gameScoreLabel = labelNode(fontName: "effra-heavy", fontText: "0", fontSize: 50, fontColorBlendFactor: 1, fontColor: UIColor.white, fontXPoz: gameScoreImages.position.x, fontYPoz: self.size.height + gameScoreLabel.frame.size.height, fontZPoz: 100)
        gameScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        //self.addChild(gameScoreLabel)
        
        
        
        livesImage = spriteNode(imageName: "Health", valueName: "Health", positionZ: 1, positionX: self.size.width * 0.86, positionY: self.size.height + livesLabel.frame.size.height) // self.size.height * 0.95
        //self.addChild(livesImage)
        
        livesLabel = labelNode(fontName: "theboldfont", fontText: "3", fontSize: 50, fontColorBlendFactor: 1, fontColor: UIColor.white, fontXPoz: livesImage.position.x, fontYPoz: self.size.height + livesLabel.frame.size.height, fontZPoz: 100)
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        //self.addChild(livesLabel)
        
        print(livesLabel.frame.size.width)
        

        
        
        tapToStartLabel = labelNode(fontName: "theboldfont", fontText: "Tap To Begin", fontSize: 100, fontColorBlendFactor: 1, fontColor: UIColor.white, fontXPoz: self.size.width * 0.5, fontYPoz: self.size.height * 0.5, fontZPoz: 1)
        //tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        
    }
    
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){bkground,stop in
            
            if self.currentGameState == GameState.inGame{
                bkground.position.y -= amountToMoveBackground
            }
            
            if bkground.position.y < -self.size.height{
                bkground.position.y += self.size.height * 2
            }
        }
        
        
    }
    
    func startGame(){
        currentGameState = GameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnToScreenActionShip = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(spawnObjectLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenActionShip,startLevelAction])
        spaceShip.run(startGameSequence)
        
        self.addChild(gameScoreImages)
        self.addChild(livesImage)
        
        let moveToScreenActionGameScoreImages = SKAction.moveTo(y: self.size.height * 0.95 , duration: 0.5)
        gameScoreImages.run(moveToScreenActionGameScoreImages)
        
        let moveToScreenActionLivesImages = SKAction.moveTo(y: self.size.height * 0.95 , duration: 0.5)
        livesImage.run(moveToScreenActionLivesImages)
        
        
        self.addChild(livesLabel)
        self.addChild(gameScoreLabel)
        let moveToScreenActionLabels = SKAction.moveTo(y: self.size.height * 0.947 , duration: 0.5) //livesImage.position.y - (livesLabel.frame.size.height / 2)
        gameScoreLabel.run(moveToScreenActionLabels)
        livesLabel.run(moveToScreenActionLabels)
        
        
        
    }
    
    func loseALife(){
        
        livesNumber -= 1
        livesLabel.text = "\(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.run(scaleSequence)
        livesImage.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
    }
    
    
    func addLife(){
        livesNumber += 1
        livesLabel.text = "\(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.run(scaleSequence)
        livesImage.run(scaleSequence)
        
    }
    
    func addScore(){
        gameScore += 1
        gameScoreLabel.text = "\(gameScore)"
        
        let scaleUpLabel = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDownLabel = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequenceLabel = SKAction.sequence([scaleUpLabel,scaleDownLabel])
        gameScoreLabel.run(scaleSequenceLabel)
        
        let scaleUpImages = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDownImages = SKAction.scale(to: 0.8, duration: 0.2)
        let scaleSequenceImages = SKAction.sequence([scaleUpImages,scaleDownImages])
        gameScoreImages.run(scaleSequenceImages)
        
        if gameScore == 5 || gameScore == 10 || gameScore == 15 || gameScore == 20 || gameScore == 30 || gameScore == 50 {
            spawnObjectLevel()
        }
        
    }
    
    func runGameOver(){
        
        currentGameState = GameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") { (bullet, stop) in
            bullet.removeAllActions()
        }
        
        for i in 1...6{
            self.enumerateChildNodes(withName: "SpawnObject\(i)") { (spawnObject, stop) in
                
                spawnObject.removeAllActions()
            }
        }
        
        let scaneChangeAction = SKAction.run(changeScane)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, scaneChangeAction])
        self.run(changeSceneSequence)
    
    }
    
    
    func changeScane(){
        let scaneMoveTo = GameOverScene(size: self.size)
        scaneMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        
        
        self.view!.presentScene(scaneMoveTo, transition: sceneTransition)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.SpaceShip && body2.categoryBitMask == PhysicsCategories.SpaceObject{
            //Oyuncu asteroide vurduğunda olacaklar
            
//            print(body2.node?.name! as Any)
//            if body2.node?.name == "SpawnObject1"{
//                addLife()
//                print("true")
//            }
            
            if body1.node != nil && body2.node?.name != "SpawnObject1" {
                spawnExpLosion(spawnPosition: body1.node!.position)
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                runGameOver()
                
            }
            else if body2.node?.name == "SpawnObject1" {
                addLife()
                body2.node?.removeFromParent()
            }
            else if body2.node != nil &&  body2.node?.name != "SpawnObject1" {
                spawnExpLosion(spawnPosition: body2.node!.position)
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                
            }
            
            
            
            
            
            
            
            

            
            

            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.SpaceObject && body2.node!.position.y < self.size.height{
            //Mermi asteroide vurduğunda olacaklar
            
            
            
            if body2.node?.name == "SpawnObject1"{
                loseALife()
            }
            else{
                addScore()
            }
            
            if body2.node != nil && body2.node?.name != "SpawnObject1"{
                spawnExpLosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    
    func spawnExpLosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "Explosion")
        
        
        
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let delete = SKAction.removeFromParent()
        
        let explosionSequance = SKAction.sequence([explosionSound,scaleIn, fadeOut, delete])
        explosion.run(explosionSequance)
        
        
    }
    

    
    
    //uzay mekiğine mermi eklendi
    func fireBullet(){
        let bullet = spriteNode(imageName: "Bullet", valueName: "Bullet", positionZ: 1, positionX: spaceShip.position.x, positionY: spaceShip.position.y)
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.SpaceObject
        
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
        
        
        
        randomObjectNumber = Int(arc4random() % 6)
        randomObjectNumber += 1
        
        let spawnObject = spriteNode(imageName: "SpawnObject\(randomObjectNumber)", valueName: "SpawnObject\(randomObjectNumber)", positionZ: 2, positionX: startPoint.x, positionY: startPoint.y)
        
        spawnObject.physicsBody = SKPhysicsBody(rectangleOf: spawnObject.size)
        spawnObject.physicsBody!.affectedByGravity = false
        spawnObject.physicsBody!.categoryBitMask = PhysicsCategories.SpaceObject
        spawnObject.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnObject.physicsBody!.contactTestBitMask = PhysicsCategories.SpaceShip | PhysicsCategories.Bullet
        
        self.addChild(spawnObject)
        
        let moveSpawnObject = SKAction.move(to: endPoint, duration: 2.5)
        let deleteSpawnObject = SKAction.removeFromParent()

        let loseALifeAction = SKAction.run(loseALife)
        let spawnObjectSequence = SKAction.sequence([moveSpawnObject, deleteSpawnObject, loseALifeAction])
        
        
        if  currentGameState == GameState.inGame{
            spawnObject.run(spawnObjectSequence)
        }
        
        
        
        let dX = endPoint.x - startPoint.x
        let dY = endPoint.y - startPoint.y
        let amountToRotate = atan2(dX, dY)
        spawnObject.zRotation = amountToRotate
        
        
    }
    
    //uzayda yok edilmesi gereken nesneler için zorluk seviyesi
    func spawnObjectLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningObject") != nil{
            self.removeAction(forKey: "spawningObject")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 2.0
        case 2: levelDuration = 1.7
        case 3: levelDuration = 1.4
        case 4: levelDuration = 1.1
        case 5: levelDuration = 0.8
        case 6: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        
        let spawn = SKAction.run(spawnSpaceObject)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningObject")
        
        print("\(levelDuration)")
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //uzay mekiğinin sahne üzerinde ki pozisyonları belirlendi.
        for touch : AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == GameState.inGame{
                spaceShip.position.x += amountDragged
            }
            
            if spaceShip.position.x > gameArea.maxX - (spaceShip.size.width / 2){
                spaceShip.position.x = gameArea.maxX - (spaceShip.size.width / 2)
            }
            
            if spaceShip.position.x < gameArea.minX + (spaceShip.size.width / 2){
                spaceShip.position.x = gameArea.minX + (spaceShip.size.width / 2)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if currentGameState == GameState.previosGame{
            startGame()
        }
        else if currentGameState == GameState.inGame{
            fireBullet()
        }
        //spawnSpaceObject()
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let nameOfTappedNode = tappedNode.name
            
            if nameOfTappedNode == "endScaneLabel"{
                
                tappedNode.name = ""
                tappedNode.removeAllActions()
                
                tappedNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),SKAction.fadeAlpha(to: 1.0, duration: 0.15) ]), completion: {
                    let sceneMovement = GameOverScene(size: self.size)
                    sceneMovement.scaleMode = self.scaleMode
                    
                    let sceneTransition = SKTransition.fade(withDuration: 0.5)
                        
                        //SKTransition.reveal(with: SKTransitionDirection.left, duration: 0.5)
                    self.view!.presentScene(sceneMovement, transition: sceneTransition)
                })
            }
            
        }
        
    }
}
