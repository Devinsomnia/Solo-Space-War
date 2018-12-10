//
//  HelperFunctions.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 9.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import CoreGraphics

public func * (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}
