//
//  BedPlateCell.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-03-01.
//
import UIKit

class BedPlateCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgrondView: UIView!
    
    static var reuseIdentifier = String(describing: BedPlateCell.self)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        
        let thinnerLines = CGMutablePath()
        
        
        self.backgrondView.layer.cornerRadius = (self.backgrondView.frame.size.height) / 2
        self.backgrondView.layer.borderWidth = 3

        
        let horizontaTickPoints = [CGPoint(x: contentView.frame.size.width - 1, y:  0), CGPoint(x: contentView.frame.size.width - 1, y:  contentView.frame.size.height)]
        thinnerLines.addLines(between: horizontaTickPoints)
        let verticalTickPoints = [CGPoint(x: 1, y:  1), CGPoint(x: contentView.frame.size.width - 3, y:  1)]
        thinnerLines.addLines(between: verticalTickPoints)
        
        context.setStrokeColor(UIColor.systemGray.cgColor)
        context.setLineCap(.square)
        context.setLineWidth(0.2)
        context.addPath(thinnerLines)
        context.strokePath()
        
        context.restoreGState()
        
    }
    
    var hand: GridItem? {
        didSet {
            layoutIfNeeded()
            
            titleLabel.text = hand?.hand?.title.uppercased()
            titleLabel.textColor = .white
            backgrondView.backgroundColor = .clear
            backgrondView.layer.borderColor = UIColor.clear.cgColor
            
            
            if hand?.hand?.title == "P" {
                backgrondView.backgroundColor = .systemBlue
                backgrondView.layer.borderColor = UIColor.systemBlue.cgColor
            }
            
            if hand?.hand?.title == "B" {
                backgrondView.backgroundColor = .systemRed
                backgrondView.layer.borderColor = UIColor.systemRed.cgColor
            }
            
            if hand?.hand?.title == "T" || hand?.hand?.title == "PT" || hand?.hand?.title == "BT"{
                titleLabel.text = "T"
                backgrondView.backgroundColor = .systemGreen
                backgrondView.layer.borderColor = UIColor.systemGreen.cgColor
            }
        }
    }
}
