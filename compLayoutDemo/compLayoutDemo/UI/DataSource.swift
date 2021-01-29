//
//  DataSource.swift
//  compLayoutDemo
//
//  Created by RYAN GREENBURG on 1/25/21.
//

import UIKit

class DataSource: UICollectionViewDiffableDataSource<Section, ColorItem> {
    private static var listCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, UIColor> {
        UICollectionView.CellRegistration { cell, indexPath, color in
            let cellConfig = cell.defaultContentConfiguration()
            cell.contentConfiguration = cellConfig
        }
    }
    
    var data: [Section]
    
    init(collectionView: UICollectionView, data: [Section]) {
        self.data = data
        
        super.init(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            
            let section = data[indexPath.section]
            switch section.context {
            case .list:
                let cell = collectionView.dequeueConfiguredReusableCell(using: Self.listCellRegistration, for: indexPath, item: item.color)
                cell.contentView.backgroundColor = item.color
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
                
                cell.backgroundColor = item.color
                cell.layer.cornerRadius = 8
                return cell
            }
        }
        
        supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as? HeaderCollectionReusableView else { return nil }
            
            headerView.titleLabel.text = data[indexPath.section].title
            headerView.backgroundColor = .secondarySystemBackground
            headerView.layer.cornerRadius = 8
            
            return headerView
        }
        registerCells(for: collectionView)
        collectionView.collectionViewLayout = configureLayout()
        applyData()
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "Header", alignment: .top)
            
            let section = self.data[sectionIndex]
            
//            let isCompactWidth = environment.traitCollection.horizontalSizeClass == .compact
            var configuredSection: NSCollectionLayoutSection!
            
            let insets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
            
            switch section.context {
            case .feature:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                group.contentInsets = insets
                
                configuredSection = NSCollectionLayoutSection(group: group)
            case .swimlane:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.2))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                group.contentInsets = insets
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                
                configuredSection = section
                
            case .grid:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(5)
                group.contentInsets = insets
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.boundarySupplementaryItems = [headerItem]
                section.supplementariesFollowContentInsets = true
                
                configuredSection = section
            case .list:
                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                configuration.headerMode = .supplementary
                
                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
                section.boundarySupplementaryItems = [headerItem]
                
                configuredSection = section
            case .nested:
                let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
                largeItem.contentInsets = insets
                
                let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
                let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
                smallItem.contentInsets = insets
                
                let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
                let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
                
                let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
                let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup, nestedGroup])
                outerGroup.contentInsets = insets
                
                let section = NSCollectionLayoutSection(group: outerGroup)
                section.boundarySupplementaryItems = [headerItem]
                configuredSection = section
            }
            
            configuredSection.contentInsets = insets
            return configuredSection
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        
        
        layout.configuration = config
        
        return layout
    }
    
    func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ColorItem>()
        
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        apply(snapshot)
    }
    
    func registerCells(for collectionView: UICollectionView) {
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: "Header", withReuseIdentifier: HeaderCollectionReusableView.reuseID)
    }
}
