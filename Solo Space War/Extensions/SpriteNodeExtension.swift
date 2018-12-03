//
//  SpriteNodeExtension.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import  SpriteKit


func spriteNode(imageName: String, valueName: String, positionZ: CGFloat, positionX: CGFloat, positionY: CGFloat)-> SKNode{
    
    let sprite = SKSpriteNode(imageNamed: "\(imageName)")
    sprite.name = valueName
    sprite.zPosition = positionZ
    sprite.position = CGPoint(x: positionX, y: positionY)
    return sprite
    
}
