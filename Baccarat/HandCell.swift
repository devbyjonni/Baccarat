//
//  HandCell.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import UIKit

class HandCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgrondView: UIView!
    @IBOutlet weak var gridView: UIView!
    
    static var reuseIdentifier = String(describing: HandCell.self)
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgrondView.layer.cornerRadius = (self.backgrondView.frame.size.height) / 2
        self.gridView.layer.borderWidth = 0.4
        self.gridView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    var hand: GridItem? {
        didSet {
            print("\(hand?.hand?.title)")
  
            titleLabel.text = hand?.hand?.title.uppercased()
            titleLabel.textColor = .white
            backgrondView.backgroundColor = UIColor.clear
            
            
            if hand?.hand?.title == "P" {
                backgrondView.backgroundColor = UIColor.systemBlue
            }
            
            if hand?.hand?.title == "B" {
                backgrondView.backgroundColor = .systemRed
            }
            
            if hand?.hand?.title == "T" {
                backgrondView.backgroundColor = .systemGreen
            }
            
            
        }
    }
}
