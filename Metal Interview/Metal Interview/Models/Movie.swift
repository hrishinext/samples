//
//  Movie.swift
//  Metal Interview
//
//  Created by Hrishi Amravatkar on 6/26/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

struct Movie {
    var movieId: String
    var title: String?
    var thumbnail_url: String?
    var imdb_score: Double?
    var rt_score: Int?
    var created_at: String?
    var updated_at: String?
    var liked: Bool?
    var source_url: String?
    var synopsis: String?
    
    init(_ inputDictionary: [String: Any]) {
        self.movieId = inputDictionary["id"] as! String
        self.title = inputDictionary["title"] as? String 
        self.thumbnail_url = inputDictionary["thumbnail_url"] as? String
        self.imdb_score = inputDictionary["imdb_score"] as? Double
        self.rt_score = inputDictionary["rt_score"] as? Int
        self.created_at = inputDictionary["rt_score"] as? String
        self.updated_at = inputDictionary["rt_score"] as? String
        self.liked = inputDictionary["rt_score"] as? Bool
        self.source_url = inputDictionary["rt_score"] as? String
        self.synopsis = inputDictionary["rt_score"] as? String
        
    }
    
    
}
