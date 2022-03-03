//
//  BedPlateViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-19.
//



import UIKit


class BedPlateViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<GridSection, GridItem?>! = nil
    var modelController: BedPlateModel!
    
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
    
    @objc private func didLoadShoe() {
        modelController.createNewShoe()
        
        for hand in modelController.model.shoes {
            addHand(hand: hand)
        }
        update(animatingDifferences: false)
    }
    
    @objc private func undoHand() {
        modelController.delete()
        update()
    }
    
    @objc private func didAddPlayer() {
        modelController.add(hand: Hand(title: "P"))
        update()
    }
    
    @objc private func didAddBanker() {
        modelController.add(hand: Hand(title: "B"))
        update()
    }
    
    @objc private func didAddTie() {
        modelController.add(hand: Hand(title: "T"))
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
extension BedPlateViewController {
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, hand) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BedPlateCell.reuseIdentifier, for: indexPath) as! BedPlateCell
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
extension BedPlateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! BedPlateCell
//        if cell.hand?.hand != nil {
//            modelController.delete(uuid: cell.hand?.hand?.uuid ?? UUID())
//            update()
//        }
    }
}

