//
//  ShoeCreater.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-20.
//

/*
 Rules
 
 Following are the rules of baccarat. The terminology can be a little confusing. To try to minimize this, when referring to a particular bet or hand, I will use capital letters. In particular Player and Banker refer to bets as well as particular sets of two or three cards each.
 
 Usually eight decks of cards are used.
 Cards are given point values as follows: Ace = 1, 2-9 = pip value, 10 and face cards = 0.
 Play begins by all players betting either on the Player or Banker. There is also a side bet on a Tie. At some tables there are also side bets on a Player Pair and/or Banker Pair. There are lots of other newer side bets, which I go into in my baccarat appendix 5.
 After all bets are down, the dealer gives two cards each to the Player and Banker hands.
 The maximum number of points in both the Player and Banker hands is 9. The way to arrive at the points per hand is to take the total points of each individual card in the hand. If the sum is more than 9, then drop the first digit. For example, if either hand had a 9 and 7, then you would drop the 1 from the total of 16, for a 6-point hand.
 A third card may or may not be dealt to either the Player or Banker hands, depending on the following rules.
 If either the Player or Banker have 8 or 9 points, it is referred to as a "natural." If there is at least one natural, then both hands will stand.
 Otherwise, if the Player's total is 5 or less, then the Player hand will draw one more card, otherwise, with 6 or 7 points, the Player hand stands.
 If the Player hand stands with 6 or 7 points, then the Banker hand will draw a third card on a total of 5 or less. Otherwise, with 6 or 7 points, the Banker will stand.
 If the Player does draw a third card, then use the Banker will use his positional advantage to decide whether to take a third card according to his total and the third card drawn to the Player, according to the following table.
 https://wizardofodds.com/games/baccarat/basics/
 
 The score of the Player and Banker hands are compared; the winner is the one that is greater. In an event of a tie, the Player and Banker bets push.
 The Tie bet wins if the Player and Banker hands tie. All other outcomes lose.
 The Player Pair bet wins if the first two cards in the Player hand are of the same rank. All other outcomes lose.
 The Banker Pair bet wins if the first two cards in the Banker hand are of the same rank. All other outcomes lose.
 */

import Foundation

struct Card {
    var value: String
    var suit: String
    var deckNumber: Int
    var pointValue: Int
}

class Hand: Hashable, Equatable {
    
    var uuid = UUID()
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(uuid)
    }
    
    static func == (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

class ShoeCreater {
    
    private enum DealtCards: Int {
        case two = 2
        case three = 3
    }
    
    private var usedShoe: [Card] = []
    private var shoe: [Card] = []
    private let totalDecks = 8
    private var totalBurnCards = 0
    private let cutCardRemaingCards = 16 //The cut card will be placed 16 cards from the bottom of the shoe.
    private lazy var cutCard = (52 * totalDecks) - cutCardRemaingCards
    private var lastHand = false
    private var oneMoreHand = false
    
    private var playerCards: [Card] = []
    private var bankerCards: [Card] = []
    private var playerScores = 0
    private var bankerScores = 0
    private var numberOfShoes = 1
    private var isFirstLoad = true
    
    private var shoeResult: [Hand] = []
    
    init() {
        resetShoe()
        createShoe()
        shuffleCards()
        burnCards()
        printOutput()
    }
    
    func loadShoe() -> [Hand] {
        resetShoe()
        shuffleCards()
        burnCards()
        printOutput()
        
        while numberOfShoes <= 1 {
            dealFirstFourCards()
            checkCutCard()
        }
        
        return shoeResult
    }
    
    private func resetShoe() {
        shoe = []
        shoeResult = []
        lastHand = false
        oneMoreHand = false
        numberOfShoes = 1
    }
    
    private func createShoe() {
        let cards = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        let suits = ["♥️", "♦️", "♠️", "♣️"]
        
        for deckNumber in 1...totalDecks {
            for suit in suits {
                for index in 0..<cards.count {
                    let pointValue = index + 1
                    let card = Card(value: cards[index], suit: suit, deckNumber: deckNumber, pointValue: pointValue > 9 ? 0 : pointValue)
                    shoe.append(card)
                }
            }
        }
    }
    
    private func shuffleCards() {
        if isFirstLoad {
            shoe = customShuffled()
            isFirstLoad = false
            print("+++++++++++++++++ Init First Shoe +++++++++++++++++ \(shoe.count)")
        } else {
            shoe = usedShoe
            shoe = customShuffled()
            usedShoe = []
            print("+++++++++++++++++ Used Shoe +++++++++++++++++ \(shoe.count)")
        }
    }
    
    private func customShuffled() -> [Card] {
        
        let chunks = shoe.chunked(into: 52)
        
        let chunk1 = chunks[0]
        let chunk2 = chunks[1]
        let chunk3 = chunks[2]
        let chunk4 = chunks[3]
        
        let chunk5 = chunks[4]
        let chunk6 = chunks[5]
        let chunk7 = chunks[6]
        let chunk8 = chunks[7]
        
        let chunks1 = (chunk4 + chunk5).shuffled()
        let chunks2 = (chunk3 + chunk6).shuffled()
        let chunks3 = (chunk2 + chunk7).shuffled()
        let chunks4 = (chunk1 + chunk8).shuffled()
        
        let shuffled = chunks1 + chunks2 + chunks3 + chunks4
        
        return shuffled
    }
    
    
    private func burnCards() {
        guard let turnOverCardValue = shoe.first?.pointValue else { return }
        let burnCards = turnOverCardValue == 0 ? 10 : turnOverCardValue
        totalBurnCards = burnCards
        usedShoe.append(contentsOf: shoe.dropFirst(burnCards))
        print("dropFirst count: \(shoe.count)")
        shoe.removeSubrange(0..<burnCards)
    }
    
    private func dealFirstFourCards() {
        playerCards = []
        bankerCards = []
        totalBurnCards = 0
        playerScores = 0
        bankerScores = 0
        
        drawPlayerCard()
        drawBankerCard()
        drawPlayerCard()
        drawBankerCard()
        
        showFirstFourCards()
    }
    
    //When the cut card appears, the dealer will finish that hand, play one more hand, and then start a new shoe.
    //If the cut card comes out instead of the first card, the dealer will finish that hand, and then start a new shoe.
    private func checkCutCard() {
        if lastHand {
            print("****** Did play last hand -> will create a new shoe. ******\n")
            lastHand = false
            numberOfShoes += 1
            
            return
        }
        
        if shoe.count == cutCardRemaingCards {
            print("****** first card WAS cut card, the dealer will finish this hand ******\n")
            // If the cut card comes out instead of the first card, the dealer will finish that hand, and then start a new shoe.
            lastHand = true
            return
        }
        
        if shoe.count < cutCardRemaingCards {
            print("****** cut card DID appear, the dealer will play one more hand ******\n")
            // When the cut card appears, the dealer will finish that hand, play one more hand, and then start a new shoe.
            lastHand = true
        }
    }
    
    private func showFirstFourCards() {
        //        guard let playerHandFirst = playerCards.first,
        //              let bankerHandFirst = bankerCards.first,
        //              let playerHandLast = playerCards.last,
        //              let bankerHandLast = bankerCards.last
        //        else { return }
        
        //        print("----------------------")
        //        print("Player Card 1: \(playerHandFirst.suit) \(playerHandFirst.pointValue)\n")
        //        print("Player Card 2: \(playerHandLast.suit) \(playerHandLast.pointValue)")
        //        print("----------------------")
        //        print("Banker Card 1: \(bankerHandFirst.suit) \(bankerHandFirst.pointValue)\n")
        //        print("Banker Card 2: \(bankerHandLast.suit) \(bankerHandLast.pointValue)")
        //        print("----------------------\n")
        
        updateScores()
        checkForNaturals()
    }
    
    private func updateScores() {
        playerScores = playerCards.count == DealtCards.three.rawValue
        ? (playerCards[0].pointValue + playerCards[1].pointValue + playerCards[2].pointValue) % 10
        : (playerCards[0].pointValue + playerCards[1].pointValue) % 10
        
        bankerScores = bankerCards.count == DealtCards.three.rawValue
        ? (bankerCards[0].pointValue + bankerCards[1].pointValue + bankerCards[2].pointValue) % 10
        : (bankerCards[0].pointValue + bankerCards[1].pointValue) % 10
    }
    
    
    private func drawPlayerCard() {
        let firstCard = shoe.removeFirst()
        
        usedShoe.append(firstCard)
        playerCards.append(firstCard)
    }
    
    private func drawBankerCard() {
        let firstCard = shoe.removeFirst()
        
        usedShoe.append(firstCard)
        bankerCards.append(firstCard)
    }
    
    private func drawThirdCards() {
        //If the Player's total is 5 or less, then the Player hand will draw one more card, otherwise, with 6 or 7 points, the Player hand stands.
        if playerScores <= 5 {
            drawPlayerCard()
        }
        
        //If the Player hand stands with 6 or 7 points, then the Banker hand will draw a third card on a total of 5 or less. Otherwise, with 6 or 7 points, the Banker will stand.
        if playerCards.count == DealtCards.two.rawValue { //2 cards are delt, Player hand stands.
            if bankerScores <= 5 {
                drawBankerCard()
            }
        }
        
        //If the Player does draw a third card, then use the Banker will use his positional advantage to decide whether to take a third card according to his total and the third card drawn to the Player, according to the following table.
        if playerCards.count == DealtCards.three.rawValue { //3 player cards are delt
            let playerCard = playerCards[2].pointValue
            if bankerScores == 0 || bankerScores == 1 || bankerScores == 2 {
                drawBankerCard()
            } else if bankerScores == 3 && playerCard != 8 {
                drawBankerCard()
            } else if bankerScores == 3 && playerCard == 8 {
                // Player has 8, banker stands.
            } else if bankerScores == 4 && [2, 3, 4, 5, 6, 7].contains(playerCard) {
                drawBankerCard()
            } else if bankerScores == 5 && [4, 5, 6, 7].contains(playerCard) {
                drawBankerCard()
            } else if bankerScores == 6 && [6, 7].contains(playerCard) {
                drawBankerCard()
            }
        }
        updateScores()
        showThirdCards()
    }
    
    private func showThirdCards() {
        if playerCards.count == DealtCards.three.rawValue {
            // let playerHand = playerCards[2]
            //            print("----------------------")
            //            print("Player Card 3: \(playerHand.suit) \(playerHand.pointValue)\n")
            //            print("----------------------\n")
        }
        
        if bankerCards.count == DealtCards.three.rawValue {
            // let bankerHand = bankerCards[2]
            //            print("----------------------")
            //            print("Banker Card 3: \(bankerHand.suit) \(bankerHand.pointValue)")
            //            print("----------------------\n")
        }
        showWinner()
    }
    
    private func checkForNaturals() {
        if (
            playerScores == 8 ||
            playerScores == 9 ||
            bankerScores == 8 ||
            bankerScores == 9
        ) {
            showWinner()
        } else {
            drawThirdCards()
        }
    }
    
    private func showWinner() {
        if playerScores > bankerScores {
            //  print("🔵 PLAYER WINS 🔵 Points: \(playerScores)\n")
            shoeResult.append(Hand(title: "P"))
        } else if playerScores < bankerScores {
            //  print("🔴 BANKER WINS 🔴 Points: \(bankerScores)\n")
            shoeResult.append(Hand(title: "B"))
        } else if playerScores == bankerScores {
            // print("🟢 TIE 🟢 Points: \(bankerScores)")
            shoeResult.append(Hand(title: "T"))
        }
    }
    
    //MARK: - Debug
    
    //    private func printCounterOutput() {
    //        print("current winners: \(currentWinners)\n")
    //        print("current winners count: \(currentWinners.count )\n")
    //    }
    
    private func printOutput() {
        print("Total burn cards: \(totalBurnCards)\n")
        print("Total decks: \(totalDecks)\n")
        print("Shoe count: \(shoe.count)\n")
        print("Cut card: \(cutCard)\n")
        print("The deck is shuffled. We are ready to play.\n")
    }
}
