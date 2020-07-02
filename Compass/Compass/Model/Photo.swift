//
//  Photo.swift
//  Compass
//
//  Created by Hrishi Amravatkar on 7/1/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

struct Photo {
    var albumId: Int
    var photoId: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    init(_ inputDictionary: [String: Any]) {
        
        //unmarshall the data here
        self.albumId = inputDictionary["albumId"] as! Int
        self.photoId = inputDictionary["id"] as! Int
        self.title = inputDictionary["title"] as! String
        self.url = inputDictionary["url"] as! String
        self.thumbnailUrl = inputDictionary["thumbnailUrl"] as! String
        
    }
}
