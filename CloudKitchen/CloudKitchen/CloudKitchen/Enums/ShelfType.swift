//
//  ShelfType.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public enum ShelfType: String {
    
    case hotShelf
    case coldShelf
    case frozenShelf
    case overflowShelf
    
    var shelfTitle: String {
        switch  self {
        case .hotShelf:
            return "Hot Shelf"
        case .coldShelf:
            return "Cold Shelf"
        case .frozenShelf:
            return "Frozen Shelf"
        case .overflowShelf:
            return "Overflow Shelf"
        }
    }
    
}
