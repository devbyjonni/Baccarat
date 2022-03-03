//
//  GridItem.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//

import Foundation

class GridItem: Hashable, Equatable {
    
    var uuid = UUID()
    var hand: Hand?
    
    init(hand: Hand? = nil) {
        self.hand = hand
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(hand)
    }
    
    static func == (lhs: GridItem, rhs: GridItem) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.hand == rhs.hand
    }
}
