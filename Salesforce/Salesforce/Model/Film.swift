//
//  Film.swift
//  Salesforce
//
//  Created by Hrishi Amravatkar on 7/24/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public class Film {
    var title: String!
    var year: String!
    var director: String?
    var poster: String?
    var plot: String?
    
    init(title: String, year: String, director: String, poster: String, plot: String) {
        self.title = title
        self.year = year
        self.director = director
        self.poster = poster
        self.plot = plot
    }
    
}
