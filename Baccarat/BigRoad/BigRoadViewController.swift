//
//  BigRoadViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import UIKit

class BigRoadViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<GridSection, GridItem?>! = nil
    var modelController: BigRoadModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelController.createGrid()
        configureDataSource()
        setupLayout()
        
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didAddPlayer), name: .didAddPlayer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddBanker), name: .didAddBanker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddTie), name: .didAddTie, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLoadShoe), name: .didLoadShoe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoHand), name: .undo, object: nil)
    }
    
    //this function is a fix to make animation work on add and delete. asyncAfter in main view controller "didTapUndoBtn".
    @objc private func undoHand() {
        modelController.delete()
        update()
        
        modelController.createNewShoe()
        for hand in modelController.model.shoes {
            addHand(hand: hand)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.update(animatingDifferences: false)
        }
    }
    
    @objc private func didLoadShoe() {
        modelController.createNewShoe()
        
        for hand in modelController.model.shoes {
            addHand(hand: hand)
        }
        update(animatingDifferences: false)
    }
    
    @objc private func didAddPlayer() {
        modelController.addPlayer()
        addHand(hand: modelController.model.shoes.last!)
        update()
    }
    
    @objc private func didAddBanker() {
        modelController.addBanker()
        addHand(hand: modelController.model.shoes.last!)
        update()
    }
    
    @objc private func didAddTie() {
        modelController.addTie()
        addHand(hand: modelController.model.shoes.last!)
        update()
    }
    
    private func addHand(hand: Hand) {
        modelController.add(hand: hand)
    }
    
    private func setupLayout() {
        let layout = HorizontalVerticalCompositionalLayout(itemsPerRow: 6, contentInsets: 0)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        
        collectionView.collectionViewLayout = layout
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension BigRoadViewController {
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, hand) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigRoadCell.reuseIdentifier, for: indexPath) as! BigRoadCell
            cell.hand = hand
            return cell
        }
        collectionView.dataSource = dataSource
        update(animatingDifferences: false)
    }
    
    private func update(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<GridSection, GridItem?>()
        modelController.gridSections.forEach { (section) in
            snapshot.appendSections([section])
            snapshot.appendItems(section.hands)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension BigRoadViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BigRoadCell
        if cell.hand?.hand != nil {
            print("\(indexPath)")
        }
    }
}
