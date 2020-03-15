//
//  Photo.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import Foundation

struct Photo: Codable {
    
    var id: Int
    
    var albumId: Int
    
    var title: String?
    
    var url: String?
    
    var thumbnailUrl: String?
    
    
    init() {
        self.id = 0
        self.albumId = 0
        self.title = nil
        self.url = nil
        self.thumbnailUrl = nil
    }
    
    init(dictionary: [String : AnyObject]) {
        self.init()
        
        if let value = dictionary["id"] as? Int {
            self.id = value
        }
        if let value = dictionary["albumId"] as? Int {
            self.albumId = value
        }
        if let value = dictionary["title"] as? String {
            self.title = value
        }
        if let value = dictionary["url"] as? String {
            self.url = value
        }
        if let value = dictionary["thumbnailUrl"] as? String {
            self.thumbnailUrl = value
        }
    }
    
}
