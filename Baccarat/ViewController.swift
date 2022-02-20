//
//  ViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-19.
//

/*
 Eight decks of cards are used.
 
 Cards are given point values as follows: Ace = 1, 2-9 = pip value, 10 and face cards = 0.
 
 At the start of a new shoe, the dealer will turn over one card. This will determine how many cards the dealer will burn, according to the baccarat value, except a 10 or face card will result in 10 cards burned.
 
 When the cut card appears, the dealer will finish that hand, play one more hand, and then start a new shoe. If the cut card comes out instead of the first card, the dealer will finish that hand, and then start a new shoe.
 
 Play begins by all players betting either on the "player", "banker", or a tie. Players may also bet various side bets.
 
 After all bets are down, the dealer gives two cards each to the player and the banker. The score of the hand is the right digit of the total of the cards. For example, if the two cards were an 8 and 7, then the total would be 15 and the score would be a 5. The scores will always range from 0 to 9 and it is impossible to bust.
 
 A third card may or may not be dealt to either the player or the dealer depending on the following rules:
 
 If either the player or the banker has a total of an 8 or a 9 they both stand. This rule overrides all other rules.
 If the player's total is 5 or less, then the player hits, otherwise the player stands.
 If the player stands, then the banker hits on a total of 5 or less. If the player does hit then use the chart below to determine if the banker hits (H) or stands (S): */


import UIKit

struct Card {
    var value: String
    var suit: String
    var deckNumber: Int
    var pointValue: Int
}

class ViewController: UIViewController {
    
    private enum DealtCards: Int {
        case two = 2
        case three = 3
    }
    
    private var shoe: [Card] = []
    private let totalDecks = 8
    
    private var playerCards: [Card] = []
    private var bankerCards: [Card] = []
    private var playerScores = 0
    private var bankerScores = 0
    
    //TODO: - Remove later
    private  var tempBurnCards = 0
    
    private func resetShoe() {
        playerCards = []
        bankerCards = []
        playerScores = 0
        bankerScores = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShoe()
    }
    
    private func loadShoe() {
        resetShoe()
        createShoe()
        shuffleCards()
        burnCards()
        printOutput()
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
        shoe.shuffle()
    }
    
    private func burnCards() {
        guard let turnOverCardValue = shoe.first?.pointValue else { return }
        let burnCards = turnOverCardValue == 0 ? 10 : turnOverCardValue
        tempBurnCards = burnCards
        shoe.removeSubrange(0..<burnCards)
    }
    
    private func dealFirstFourCards() {
        drawPlayerCard()
        drawBankerCard()
        drawPlayerCard()
        drawBankerCard()
        
        showFirstFourCards()
    }
    
    private func showFirstFourCards() {
        guard let playerHandFirst = playerCards.first,
              let bankerHandFirst = bankerCards.first,
              let playerHandLast = playerCards.last,
              let bankerHandLast = bankerCards.last
        else { return }
        
        print("----------------------")
        print("Player Card 1: \(playerHandFirst.suit) \(playerHandFirst.pointValue)\n")
        print("Player Card 2: \(playerHandFirst.suit) \(playerHandLast.pointValue)")
        print("----------------------")
        print("Banker Card 1: \(bankerHandFirst.suit) \(bankerHandFirst.pointValue)\n")
        print("Banker Card 2: \(bankerHandFirst.suit) \(bankerHandLast.pointValue)")
        print("----------------------\n")
        
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
        playerCards.append(shoe.removeFirst())
    }
    
    private func drawBankerCard() {
        bankerCards.append(shoe.removeFirst())
    }
    
    private func drawThirdCards() {
        if playerScores <= 5 {
            drawPlayerCard()
        }
        
        if playerCards.count == DealtCards.two.rawValue { //2 cards
            if bankerScores <= 5 {
                drawBankerCard()
            }
        }
        
        if playerCards.count == DealtCards.three.rawValue { //3 cards
            let playerCard = playerCards[2].pointValue
            if bankerScores == 0 || bankerScores == 1 || bankerScores == 2 {
                drawBankerCard()
            } else if bankerScores == 3 && playerCard != 8 {
                drawBankerCard()
            } else if bankerScores == 3 && playerCard == 8 {
                // print("Banker 3 vs 8 exception fires")
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
            let playerHand = playerCards[2]
            print("----------------------")
            print("Player Card 3: \(playerHand.suit) \(playerHand.pointValue)\n")
            print("----------------------\n")
        }
        
        if bankerCards.count == DealtCards.three.rawValue {
            let bankerHand = bankerCards[2]
            print("----------------------")
            print("Banker Card 3: \(bankerHand.suit) \(bankerHand.pointValue)")
            print("----------------------\n")
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
            print("🔵 PLAYER WINS: \(playerScores)\n")
        } else if playerScores < bankerScores {
            print("🔴 BANKER WINS: \(bankerScores)\n")
        } else if playerScores == bankerScores {
            print("🟢 TIE \(bankerScores)")
        }
    }
    
    
    //MARK: - Actions
    @IBAction func didTapDealBtn(_ sender: UIButton) {
        resetShoe()
        dealFirstFourCards()
        print("Total cards: \(shoe.count)\n")
    }
    
    //MARK: - Debug
    private func printOutput() {
        //        for shoe in shoe {
        //            print("\(shoe)\n")
        //        }
        print("Total burn cards: \(tempBurnCards)\n")
        print("Total decks: \(totalDecks)\n")
        print("Total cards: \(shoe.count)\n")
        print("The deck is shuffled. We are ready to play.\n")
    }
}
