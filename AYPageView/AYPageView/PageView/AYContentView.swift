//
//  AYPageContentView.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

private let kContentCellID = "kContentCellID"
class AYContentView: UIView {
    
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parsentVc: UIViewController?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.dataSource = self
        return collectionView
    }()
    

    init(frame: CGRect, childVcs: [UIViewController], parsentVc: UIViewController) {
        self.childVcs = childVcs
        self.parsentVc = parsentVc
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}

extension AYContentView {
    
    fileprivate func setupUI() {
        // 子控制器添加到父控制器中(push、modal时会用到)
        for childVc in childVcs {
            parsentVc?.addChild(childVc)
        }
        addSubview(collectionView)
    }
    
}


extension AYContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = self.bounds
        cell.contentView.addSubview(childVc.view)
  
        return cell
    }
}

extension AYContentView: AYTitleViewDelegate {
    
    func titleView(_ titleView: AYTitleView, targetIndex: Int) {
        let indexPath = IndexPath.init(row: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
