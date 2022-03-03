//
//  HorizontalVerticalCompositionalLayout.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import UIKit

//MARK: - UICollectionViewCompositionalLayout
class HorizontalVerticalCompositionalLayout: UICollectionViewCompositionalLayout {
    init(itemsPerRow: Int, contentInsets: CGFloat = 0.0) {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0 / 6), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0 )
        
        section.orthogonalScrollingBehavior = .continuous
        
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

