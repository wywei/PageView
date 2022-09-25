//
//  AYPageCollectionViewFlowLayout.swift
//  AYPageView
//
//  Created by Andy on 2022/9/22.
//

import UIKit

class AYPageCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var cols: Int = 4
    var rows: Int = 4
    fileprivate var cellAttrs: [UICollectionViewLayoutAttributes] = []
    fileprivate lazy var maxWidth:CGFloat = 0
    
}


extension AYPageCollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()

        let sectionCount = collectionView!.numberOfSections
        
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat (cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        
        var prePageCount: Int = 0
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0..<itemCount {
                let indexPath = IndexPath(item: j, section: i)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                // 第几页
                let page = j / (cols * rows)
                let index = j % (cols * rows)

                let itemY:CGFloat = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                // 计算x
                let itemX:CGFloat = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                cellAttrs.append(attr)
            }
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        // 计算最大宽度
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }    
    
}


extension AYPageCollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
