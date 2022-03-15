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
    var viewModel: BedPlateViewModel!
    
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
    
    @objc private func didDeleteData() {
        viewModel.delete()
        updateSnapshot(animatingDifferences: false)
    }
    
    @objc private func didAddData() {
        viewModel.update()
        updateSnapshot()
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
extension BedPlateViewController {
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, hand) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BedPlateCell.reuseIdentifier, for: indexPath) as! BedPlateCell
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
extension BedPlateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath) as! BedPlateCell
        //        if cell.hand?.hand != nil {
        //            modelController.delete(uuid: cell.hand?.hand?.uuid ?? UUID())
        //            update()
        //        }
    }
}

