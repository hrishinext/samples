//
//  ShelfType.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public enum ShelfType: String {
    
    case hot
    case cold
    case frozen
    case overflow
    
    var shelfTitle: String {
        switch  self {
        case .hot:
            return "Hot Shelf"
        case .cold:
            return "Cold Shelf"
        case .frozen:
            return "Frozen Shelf"
        case .overflow:
            return "Overflow Shelf"
        }
    }
    
}
