//
//  ViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-19.
//



import UIKit

enum CustomSection: CaseIterable {
    case main
}

struct Hand: Hashable {
    var uuid: UUID
    var title: String
}

struct Grid: Hashable {
    var uuid: UUID
    var title: String
    var Hand: Hand?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let shoeCreater = ShoeCreater()
    private var dataSource: UICollectionViewDiffableDataSource<CustomSection, Grid>! = nil
    private var hands: [Grid] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // hands = shoeCreater.preload(numberOfShoes: 3).first!
       // shoeCreater.printCounterOutput()
        hands = (1...102).compactMap { Grid(uuid: UUID(), title: String($0))}
        configureDataSource()
        setupLayout()
    }
    
    private func setupLayout() {
        let collectionViewLayout = HorizontalVerticalCompositionalLayout(itemsPerRow: 6, contentInsets: 0)
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    //MARK: - Actions
    @IBAction func didTapDealBtn(_ sender: UIButton) {
        shoeCreater.dealFirstFourCards()
        shoeCreater.checkCutCard()
        shoeCreater.printCounterOutput()
    }
}

//BigRod, BedPlate
class HorizontalVerticalCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init(itemsPerRow: Int, contentInsets: CGFloat = 0.0) {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: contentInsets, leading: contentInsets, bottom: contentInsets, trailing: contentInsets)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0 / CGFloat(itemsPerRow)), heightDimension: .fractionalHeight(1.0))
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

//MARK: - UICollectionViewDiffableDataSource
extension ViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, hand) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HandCell.reuseIdentifier, for: indexPath) as! HandCell
            cell.hand = hand
            return cell
        }
        collectionView.dataSource = dataSource
        update(animatingDifferences: false)
    }
    
    private func update(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<CustomSection, Grid>()
        snapshot.appendSections([CustomSection.main])
        snapshot.appendItems(hands)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
