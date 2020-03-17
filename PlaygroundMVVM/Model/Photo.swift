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
    
}
