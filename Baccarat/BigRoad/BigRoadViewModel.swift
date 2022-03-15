//
//  BigRoadViewModel.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//

import Foundation

class BigRoadViewModel {
    
    private var currentSection = 0
    private var nextIndex = 0
    private var prevHand = ""
    private var sectionIndexBeforeDragon = 0
    private var dragonIndex = 0
    private var didStartDragon = false
    
    private let model: ModelController
    private var deleteIndexPaths: [IndexPath] = []
    var gridSections: [GridSection] = []
    
    
    init(model: ModelController) {
        self.model = model
    }
    
    func loadShoe() {
        reset()
        createGrid()
        
        for hand in model.shoes {
            add(hand: hand)
        }
    }
    
    func update() {
        add(hand: model.shoes.last!)
    }
    
    func createGrid() {
        var sectionHands: [GridSection] = []
        for _ in 0..<70 {
            var hands = [GridItem]()
            for _ in 0..<6 {
                hands.append(GridItem())
            }
            let sections = GridSection(hands: hands)
            sectionHands.append(sections)
        }
        gridSections = sectionHands
    }
    
    func delete() {
        guard deleteIndexPaths.count > 0 else { return }
        //        let idx = deleteIndexPaths.removeLast()
        //        gridSections[idx.section].hands.remove(at: idx.item)
        //        gridSections[idx.section].hands.insert(GridItem(hand: nil), at: idx.item)
        model.deleteHand()
    }
    
    private func reset() {
        currentSection = 0
        nextIndex = 0
        prevHand = ""
        sectionIndexBeforeDragon = 0
        dragonIndex = 0
        didStartDragon = false
        deleteIndexPaths = []
        gridSections = []
    }
    
    private func updateDeleteIndex(sectionIndex: Int, itemIndex: Int, hand: Hand) {
        let idx = IndexPath(item: itemIndex, section: sectionIndex)
        //deleteIndex[hand.uuid.uuidString] = idx
        deleteIndexPaths.append(idx)
    }
    
    private func updateHand(sectionIndex: Int, itemIndex: Int, hand: Hand) {
        gridSections[sectionIndex].hands.remove(at: itemIndex)
        let gridItem = GridItem(hand: hand)
        gridSections[sectionIndex].hands.insert(gridItem, at: itemIndex)
    }
    
    
    private func add(hand: Hand) {
        //First hand
        if prevHand == "" {
            if hand.title == "T" {
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                prevHand = "T"
            }
            
            if hand.title == "P" {
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                nextIndex += 1
                prevHand = "P"
            }
            
            if hand.title == "B" {
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                nextIndex += 1
                prevHand = "B"
            }
            logOut()
            return
        }
        
#warning("fix tie hands")
        //Scond hand, if T
        if prevHand == "T" {
            if hand.title == "P" || hand.title == "PT" {
                hand.title = "PT" //Save
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                nextIndex += 1
                prevHand = "P"
            }
            if hand.title == "B" || hand.title == "BT" {
                hand.title = "BT" //Save
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                nextIndex += 1
                prevHand = "B"
            }
            logOut()
            return
        }
        
        
        if !didStartDragon {
            sectionIndexBeforeDragon = currentSection // x
            dragonIndex = nextIndex - 1  // y
        }
        
        
        if hand.title == "T" || hand.title == "PT" || hand.title == "BT" {
            
            if prevHand == "P" || prevHand == "PT" {
                hand.title = "PT" //Save
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex - 1, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex - 1, hand: hand)
                prevHand = "P"
            }
            
            if prevHand == "B" || prevHand == "BT"{
                hand.title = "BT" //Save
                updateHand(sectionIndex: currentSection, itemIndex: nextIndex - 1, hand: hand)
                updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex - 1, hand: hand)
                prevHand = "B"
            }
        }
        
        if hand.title == "P" {
            
            if prevHand == "P" {
                
                if didStartDragon == false && nextIndex < 6 && gridSections[currentSection].hands[nextIndex].hand == nil { // If true, dragon tail will start.
                    
                    updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                    nextIndex += 1
                } else {
                    currentSection += 1 //shift sectionIndex, not the same hand
                    updateHand(sectionIndex: currentSection, itemIndex: dragonIndex, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: dragonIndex, hand: hand)
                    didStartDragon = true
                }
                
            } else {
                
                if didStartDragon {
                    //dragonIndex == 1, test if we are on the first row after mutliple dragon tails.
                    currentSection = dragonIndex == 0 ? (currentSection + 1) : (sectionIndexBeforeDragon + 1)
                    
                    //Reset dragon
                    didStartDragon = false
                    sectionIndexBeforeDragon = 0
                    dragonIndex = 0
                    
                    updateHand(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    nextIndex = 1
                } else {
                    currentSection += 1
                    updateHand(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    nextIndex = 1
                }
            }
            prevHand = "P"
        }
        
        if hand.title == "B" {
            
            if prevHand == "B" {
                
                if didStartDragon == false && nextIndex < 6 && gridSections[currentSection].hands[nextIndex].hand == nil {
                    
                    updateHand(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: nextIndex, hand: hand)
                    nextIndex += 1
                } else {
                    currentSection += 1 //shift section
                    updateHand(sectionIndex: currentSection, itemIndex: dragonIndex, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: dragonIndex, hand: hand)
                    didStartDragon = true
                }
                
            } else {
                
                if didStartDragon {
                    currentSection = dragonIndex == 0 ? (currentSection + 1) : (sectionIndexBeforeDragon + 1)
                    
                    //Reset dragon
                    didStartDragon = false
                    sectionIndexBeforeDragon = 0
                    dragonIndex = 0
                    
                    updateHand(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    nextIndex = 1
                } else {
                    currentSection += 1
                    updateHand(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    updateDeleteIndex(sectionIndex: currentSection, itemIndex: 0, hand: hand)
                    nextIndex = 1
                }
            }
            prevHand = "B"
        }
        logOut()
        
    }
    
    func logOut() {
        print("** currentSection \(currentSection)")
        print("**** nextIndex \(nextIndex)")
        print("****** prevHand \(prevHand)")
        print("******** sectionIndexBeforeDragon \(sectionIndexBeforeDragon)")
        print("********** dragonIndex \(dragonIndex)")
        print("************ didStartDragon \(didStartDragon)")
        print("************** deleteIndexPaths \(deleteIndexPaths)")
    }
}
