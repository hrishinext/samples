//
//  Photo.swift
//  Affirm
//
//  Created by Hrishi Amravatkar on 7/16/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import Foundation

class Photo {
    
    var photoId: String!
    var title: String?
    var url: String?
    var height: Int?
    var width: Int?
    var owner: String?
    var secret: String?
    
    init(photoId: String, title: String, url: String, height: Int, width: Int, owner: String, secret: String ) {
        self.photoId = photoId
        self.title = title
        self.url = url
        self.height = height
        self.width = width
        self.owner = owner
        self.secret = secret
    }
    
}
