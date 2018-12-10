//
//  SKSpriteNode+GIF.swift
//  Solo Space War
//
//  Created by Tuncay Cansız on 9.12.2018.
//  Copyright © 2018 Tuncay Cansız. All rights reserved.
//

import SpriteKit
import ImageIO

extension SKSpriteNode{
    
//    func animateWithRemoteGIF(url: NSURL){
//
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
//        config.URLCache = NSURLCache.sharedURLCache()
//
//        let session = NSURLSession(configuration: config)
//
//        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
//            [weak self] url, response, error in
//            if error == nil, let url = url, data = NSData(contentsOfURL: url), textures = SKSpriteNode.gifWithData(data) {
//                dispatch_async(dispatch_get_main_queue()) {
//                    if let strongSelf = self {
//                        let action = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1))
//                        strongSelf.runAction(action)
//                    }
//                }
//            } else {
//                print(error?.domain)
//                print(error?.code)
//            }
//            session.finishTasksAndInvalidate()
//        })
//
//        downloadTask.resume()
//
//    }
    
    
    func animateWithLocalGIF(fileNamed name:String){
        
        // Check gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return
        }
        
        // Validate data
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return
        }
        
        if let textures = SKSpriteNode.gifWithData(data: imageData){
            let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
            self.run(action)
        }
    }
    
    
    public class func gifWithData(data: NSData) -> [SKTexture]? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return SKSpriteNode.animatedImageWithSource(source: source)
    }
    
    
    class func animatedImageWithSource(source: CGImageSource) -> [SKTexture]? {
        let count = CGImageSourceGetCount(source)
        var delays = [Int]()
        var textures = [SKTexture]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: image)
                textures.append(texture)
            }
            
            // At it's delay in cs
            let delaySeconds = SKSpriteNode.delayForImageAtIndex(index: Int(i),
                                                                 source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        
        // may use later
        let timePerTexture = Double(duration) / 1000.0 / Double(count)
        
        return textures
    }
    
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            
            gcd = SKSpriteNode.gcdForPair(val, gcd)
            //gcd = SKSpriteNode.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
//        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
//        let gifProperties: CFDictionary = unsafeBitCast(
//            CFDictionaryGetValue(cfProperties,
//                                 UnsafeRawPointer(kCGImagePropertyGIFDictionary)),
//            to: CFDictionary.self)
        
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        
        // Get delay time
//        var delayObject: AnyObject = unsafeBitCast(
//            CFDictionaryGetValue(gifProperties,
//                                 unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
//            AnyObject.self)
//        if delayObject.doubleValue == 0 {
//            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
//                                                             unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
//        }
        
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        
//        delay = delayObject as! Double
//
//        if delay < 0.1 {
//            delay = 0.1 // Make sure they're not too fast
//        }
//
//        return delay
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
//    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
//        var a = a
//        var b = b
//        // Check if one of them is nil
//        if b == nil || a == nil {
//            if b != nil {
//                return b!
//            } else if a != nil {
//                return a!
//            } else {
//                return 0
//            }
//        }
//
//        // Swap for modulo
//        if a < b {
//            let c = a
//            a = b
//            b = c
//        }
//
//        // Get greatest common divisor
//        var rest: Int
//        while true {
//            rest = a! % b!
//
//            if rest == 0 {
//                return b! // Found it
//            } else {
//                a = b
//                b = rest
//            }
//        }
//    }
    
    
    
}
