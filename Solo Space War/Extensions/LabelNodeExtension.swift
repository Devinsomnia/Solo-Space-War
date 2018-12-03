//
//  LabelNodeExtension.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 3.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

func labelNode(fontName: String, fontText: String, fontSize: CGFloat, fontColorBlendFactor: CGFloat, fontColor: UIColor, fontXPoz: CGFloat, fontYPoz: CGFloat, fontZPoz: CGFloat)-> SKLabelNode{
    let label = SKLabelNode(fontNamed: "\(fontName)")
    label.text = fontText
    label.colorBlendFactor = fontColorBlendFactor
    label.fontSize = fontSize
    label.color = fontColor
    label.position = CGPoint(x: fontXPoz, y: fontYPoz)
    label.zPosition = fontZPoz
    
    return label
    
}
