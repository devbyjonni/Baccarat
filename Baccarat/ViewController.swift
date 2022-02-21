//
//  ViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-19.
//



import UIKit

struct GridSection: Hashable {
    var uuid: UUID
    var hands: [GridItem?]
}


struct GridItem: Hashable {
    var uuid: UUID
    var hand: Hand?
}


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let shoeCreater = ShoeCreater()
    private var dataSource: UICollectionViewDiffableDataSource<GridSection, GridItem?>! = nil
    private var sectionHands: [GridSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var shoes = shoeCreater.preload(numberOfShoes: 3).first!

        for _ in 0..<100 {
            
            var hands: [GridItem] = []
            for _ in 0..<6 {
                var shoe: Hand?
                if shoes.count > 1 { shoe = shoes.removeFirst() }
                hands.append(GridItem(uuid: UUID(), hand: shoe))
            }
            
            let sections = GridSection(uuid: UUID(), hands: hands)
            sectionHands.append(sections)
        }
        
        configureDataSource()
        setupLayout()
        
        collectionView.delegate = self
    }
    
    private func setupLayout() {
        let layout = HorizontalVerticalCompositionalLayout(itemsPerRow: 6, contentInsets: 0)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: - Actions
    @IBAction func didTapDealBtn(_ sender: UIButton) {
        shoeCreater.dealFirstFourCards()
        shoeCreater.checkCutCard()
        shoeCreater.printCounterOutput()
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
        var snapshot = NSDiffableDataSourceSnapshot<GridSection, GridItem?>()
        sectionHands.forEach { (section) in
            snapshot.appendSections([section])
            snapshot.appendItems(section.hands)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
}

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



