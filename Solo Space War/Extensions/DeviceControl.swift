//
//  DeviceControl.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 5.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//


import SpriteKit

//Sprite boyutlarını ve screen size'larını geriye döndürür.
struct Device{
    
    static var deviceModel : String {
        let model = UIDevice.current.model
        return model
    }
    
    static var screenWidth : CGFloat{
        let screenWidth = UIScreen.main.nativeBounds.size.width
        return screenWidth
    }
    
    static var screenHeight : CGFloat{
        let screenHeight = UIScreen.main.nativeBounds.size.height
        return screenHeight
    }
    
}

