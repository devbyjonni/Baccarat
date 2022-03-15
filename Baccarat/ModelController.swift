//
//  ModelController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import Foundation

class ModelController {
    
    private let shoeCreater: ShoeCreater
    
    
    var shoes: [Hand] {
        didSet {
           
             //print("did update data")
        }
    }
    
    init(shoeCreater: ShoeCreater) {
        self.shoeCreater = shoeCreater
        self.shoes = []
    }
    
    func createNewShoe() {
        shoes = shoeCreater.loadShoe()
        NotificationCenter.default.post(name: .didCreateShoe, object: nil)
    }
    
    func addPlayer() {
        shoes.append(Hand(title: "P"))
        NotificationCenter.default.post(name: .didAddData, object: nil)
    }
    
    func addBanker() {
        shoes.append(Hand(title: "B"))
        NotificationCenter.default.post(name: .didAddData, object: nil)
    }
    
    func addTie() {
        shoes.append(Hand(title: "T"))
        NotificationCenter.default.post(name: .didAddData, object: nil)
    }
    
    func deleteHand() {
     shoes.removeLast()
        //NotificationCenter.default.post(name: .didDeleteData, object: nil)
    }
}
