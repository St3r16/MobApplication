//
//  CollectionLayout.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/5/21.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
    
    //MARK: - Private API
    private typealias LayoutSpacing = (vertical: CGFloat, horisontal: CGFloat)
    
    private var layoutCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    private var spacing: LayoutSpacing {
        return (vertical: 1, horisontal: 1)
    }
    
    private var numberOfColumns: Int {
        return 5
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var contentHeight: CGFloat = 0
    

    
    private func addLayout(rect: CGRect, at idx: IndexPath) {

        let targetLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: idx)
        targetLayoutAttributes.frame = rect
        layoutCache[idx] = targetLayoutAttributes
        
    }
    
    private func normalCellSize() -> CGSize {

        let totolRowSplits = CGFloat(numberOfColumns - 1)
        let totolRowSpacing = totolRowSplits * spacing.horisontal
        let widthForCells = contentWidth - totolRowSpacing
        let cellSide = widthForCells / CGFloat(numberOfColumns)

        return CGSize(width: cellSide, height: cellSide)

    }

    private func expandedCellSize(using normalCellSize: CGSize, multiplier: CGFloat) -> CGSize {

        let absobedSpaces = multiplier - 1
        let absorberSpacing = absobedSpaces * spacing.horisontal
        let cellSide = normalCellSize.width * multiplier + absorberSpacing

        return CGSize(width: cellSide, height: cellSide)

    }
    
    
    //MARK: - Overrides
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        layoutCache.removeAll()
        
        let multiplier: CGFloat = 3
        let normalCellSize = self.normalCellSize()
        let expandedCellSize = self.expandedCellSize(using: normalCellSize, multiplier: multiplier)
        
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        let period = 7
        
        for sectionNumber in 0..<collectionView.numberOfSections {
            for rowNumber in 0..<collectionView.numberOfItems(inSection: sectionNumber) {
                
                let index = (rowNumber) % period
                let indexPath = IndexPath(row: rowNumber, section: sectionNumber)
                let point = CGPoint(x: xOffset, y: yOffset)
                
                switch index {
                case 0:
                    
                    addLayout(rect: CGRect(origin: point, size: normalCellSize), at: indexPath)
                    xOffset += normalCellSize.width + spacing.horisontal
                    
                    contentHeight = yOffset + normalCellSize.height
                case 1:
                    addLayout(rect: CGRect(origin: point, size: expandedCellSize), at: indexPath)
                    xOffset += expandedCellSize.width + spacing.horisontal
                    
                    contentHeight = yOffset + expandedCellSize.height
                case 3, 5:
                    addLayout(rect: CGRect(origin: point, size: normalCellSize), at: indexPath)
                    xOffset += normalCellSize.width + 2 * spacing.horisontal + expandedCellSize.width
                    
                case 2, 4, 6:
                    addLayout(rect: CGRect(origin: point, size: normalCellSize), at: indexPath)
                    xOffset = 0
                    yOffset += normalCellSize.width + spacing.vertical
                    
                default:
                    fatalError("Invalid layout!")
                }

            }
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        if layoutCache.isEmpty {
            prepare()
        }
        for (_, layoutAttributes) in layoutCache {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutCache[indexPath]
    }

}
