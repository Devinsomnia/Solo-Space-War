//
//  GameScene.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor.gray
        
        let end = labelNode(fontName: "effra-heavy", fontText: "Go to End Scene", fontSize: 100, fontColorBlendFactor: 1, fontColor: UIColor.white, fontXPoz: self.size.width / 2, fontYPoz: self.size.height / 2, fontZPoz: 1)
        end.name = "endScaneLabel"
        self.addChild(end)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
