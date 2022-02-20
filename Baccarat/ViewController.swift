//
//  ViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-19.
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


import UIKit


class ViewController: UIViewController {
    
    let shoeCreater = ShoeCreater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let winners = shoeCreater.preload(numberOfShoes: 3)
        shoeCreater.printCounterOutput()
    }
    
    //MARK: - Actions
    @IBAction func didTapDealBtn(_ sender: UIButton) {
        shoeCreater.dealFirstFourCards()
        shoeCreater.checkCutCard()
        shoeCreater.printCounterOutput()
    }
}
