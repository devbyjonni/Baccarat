//
//  BedPlateModel.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//

import Foundation

class BedPlateModel {
    
    let model: ModelController
    private var currentSection = 0
    private var currentIndex = 0
    var gridSections: [GridSection] = []
    
    init(model: ModelController) {
        self.model = model
    }
    
    func createNewShoe() {
        reset()
        createGrid()
    }
    
    private func reset() {
        currentSection = 0
        currentIndex = 0
        gridItemTable = [:]
        gridItemArr = []
    }
    
    func createGrid() {
        var sectionHands: [GridSection] = []
        for _ in 0..<30 {
            var hands = [GridItem]()
            for _ in 0..<6 {
                hands.append(GridItem())
            }
            let sections = GridSection(hands: hands)
            sectionHands.append(sections)
        }
        self.gridSections = sectionHands
    }
    
    private var gridItemArr = [IndexPath]()
    private var gridItemTable = [String : IndexPath]()
    
    func delete() {
        let idx = gridItemArr.removeLast()
        gridSections[idx.section].hands.remove(at: idx.item)
        gridSections[idx.section].hands.insert(GridItem(hand: nil), at: idx.item)

        currentSection = idx.section
        currentIndex = idx.item
    }
    
    func add(hand: Hand) {

        if hand.title == "P" {
            if currentIndex < 6 && gridSections[currentSection].hands[currentIndex].hand == nil { // If true, dragon tail will start.
                gridSections[currentSection].hands.remove(at: currentIndex)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: currentIndex)
                let idx = IndexPath(item: currentIndex, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                currentIndex += 1
            } else {
                currentSection += 1 //shift sectionIndex, not the same hand
                gridSections[currentSection].hands.remove(at: 0)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: 0)
                
                let idx = IndexPath(item: 0, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                
                currentIndex = 1
            }
        }
        
        if hand.title == "B" {
            if currentIndex < 6 && gridSections[currentSection].hands[currentIndex].hand == nil { // If true, dragon tail will start.
                gridSections[currentSection].hands.remove(at: currentIndex)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: currentIndex)
                
                let idx = IndexPath(item: currentIndex, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                
                currentIndex += 1
            } else {
                currentSection += 1 //shift sectionIndex, not the same hand
                gridSections[currentSection].hands.remove(at: 0)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: 0)
                
                let idx = IndexPath(item: 0, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                
                currentIndex = 1
            }
        }
        
        if hand.title == "T" {
            if currentIndex < 6 && gridSections[currentSection].hands[currentIndex].hand == nil { // If true, dragon tail will start.
                gridSections[currentSection].hands.remove(at: currentIndex)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: currentIndex)
                
                let idx = IndexPath(item: currentIndex, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                
                currentIndex += 1
            } else {
                currentSection += 1 //shift sectionIndex, not the same hand
                gridSections[currentSection].hands.remove(at: 0)
                gridSections[currentSection].hands.insert(GridItem(hand: hand), at: 0)
                
                let idx = IndexPath(item: 0, section: currentSection)
                gridItemTable[hand.uuid.uuidString] = idx
                gridItemArr.append(idx)
                
                currentIndex = 1
            }
        }
    }
}
