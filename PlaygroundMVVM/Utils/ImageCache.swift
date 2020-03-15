//
//  ImageCache.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import UIKit



class ImageCache {

    static let shared = ImageCache()
    
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    private init(){
        
    }
    
    func get(key: String) -> UIImage? {
        if let cacheImage = imageCache.object(forKey: key as AnyObject) as? UIImage {
            return cacheImage
        }
        return nil
    }
    
    func put(key: String, image: UIImage) {
        imageCache.setObject(image, forKey: key as AnyObject)
    }
}
