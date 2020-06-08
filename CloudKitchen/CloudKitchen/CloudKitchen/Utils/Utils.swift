//
//  Utils.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

class Utils {
    
    static func calculateOrderValue(_ order:Order) -> Int {
        let shelfDecayModifier: Int = (order.shelfType == ShelfType.overflow) ? 2 : 1
        let value = ((order.shelfLife) - (Int(order.decayRate) * order.orderAge * shelfDecayModifier)) / order.shelfLife
        return value
    }
    
}
