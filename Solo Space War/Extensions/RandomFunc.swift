//
//  RandomFunc.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 9.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit

func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}
