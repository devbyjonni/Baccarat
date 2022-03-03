//
//  ModelController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import Foundation

class ModelController {
    
    private let shoeCreater: ShoeCreater
    private(set) var shoes: [Hand]
    
    init(shoeCreater: ShoeCreater) {
        self.shoeCreater = shoeCreater
        self.shoes = []
    }
    
    func createNewShoe() {
        shoes = shoeCreater.loadShoe()
        NotificationCenter.default.post(name: .didLoadShoe, object: nil)
    }
    
    func addPlayer() {
        shoes.append(Hand(title: "P"))
    }
    
    func addBanker() {
        shoes.append(Hand(title: "B"))
    }
    
    func addTie() {
        shoes.append(Hand(title: "T"))
    }
    
    func deleteHand() {
        shoes.removeLast()
    }
}
