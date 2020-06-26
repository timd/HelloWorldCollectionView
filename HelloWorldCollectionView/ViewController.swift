//
//  ViewController.swift
//  HelloWorldCollectionView
//
//  Created by Tim Duckett on 26.06.20.
//

import UIKit

enum Section {
    case first
    case second
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupData()
        setupLayout()
        applyInitialSnapshot()
    }
    
    func configureCell() -> UICollectionView.CellRegistration<UICollectionViewCell, String> {
        
        return UICollectionView.CellRegistration<UICollectionViewCell, String> { (cell, indexPath, item) in
            
            var content = UIListContentConfiguration.cell()
            
            content.text = item
            content.textProperties.font = .systemFont(ofSize: 20)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 5.0 / cell.traitCollection.displayScale
            background.backgroundColor = .cyan
            cell.backgroundConfiguration = background

        }
        
    }
    
    func setupData() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView,
                                                                         cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCell(),
                                                                    for: indexPath, item: item)
            return cell
        })
        
    }
    
    func setupLayout() {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            var group: NSCollectionLayoutGroup
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            
            switch sectionIndex {
            
            case 0:
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                
            default:
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
        collectionView.setCollectionViewLayout(layout, animated: false, completion: nil)
        
    }
    
    func applyInitialSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.first, .second])
        
        let firstSectionItems = (1...19).map { "Item \($0)"}
        snapshot.appendItems(firstSectionItems, toSection: .first)
        
        let secondSectionItems = (20...59).map { "Number \($0)"}
        snapshot.appendItems(secondSectionItems, toSection: .second)
        
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        
    }

}

