//
//  Helper.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//

import Foundation

struct App {
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
