//
//  GridSection.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//

import Foundation

class GridSection: Hashable, Equatable {
    var uuid = UUID()
    var hands: [GridItem]
    
    init(hands: [GridItem]) {
        self.hands = hands
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(hands)
    }
    
    static func == (lhs: GridSection, rhs: GridSection) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.hands == rhs.hands
    }
}
