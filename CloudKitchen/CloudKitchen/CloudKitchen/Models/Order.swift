//
//  Order.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

struct Order {
    var orderId: String
    var name: String
    var temp: String
    var shelfLife: Int
    var decayRate: Double
    var shelfType: ShelfType
    
    init(_ inputDictionary: [String: AnyObject]) {
        self.orderId = inputDictionary["id"] as! String
        self.name = inputDictionary["name"] as! String
        self.temp = inputDictionary["temp"] as! String
        self.shelfLife = inputDictionary["shelfLife"] as! Int
        self.decayRate = inputDictionary["decayRate"] as! Double
        self.shelfType = ShelfType(rawValue: self.temp)!
    }
}
