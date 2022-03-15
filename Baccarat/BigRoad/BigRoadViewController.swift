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
    
    var viewModel: BigRoadViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.createGrid()
        configureDataSource()
        configureLayout()
        
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didCreateShoe), name: .didCreateShoe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDeleteData), name: .didDeleteData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddData), name: .didAddData, object: nil)
    }
    
    @objc private func didCreateShoe() {
        viewModel.loadShoe()
        updateSnapshot(animatingDifferences: false)
    }
    
    @objc private func didAddData() {
        viewModel.update()
        updateSnapshot()
    }
    
    //this function is a fix to make animation work on add and delete. asyncAfter in main view controller "didTapUndoBtn".
    @objc private func didDeleteData() {
        viewModel.delete()
        viewModel.loadShoe()
        updateSnapshot(animatingDifferences: false)
    }
    
    private func configureLayout() {
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
        updateSnapshot(animatingDifferences: false)
    }
    
    private func updateSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<GridSection, GridItem?>()
        viewModel.gridSections.forEach { (section) in
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
