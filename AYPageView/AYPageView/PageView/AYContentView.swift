//
//  AYPageContentView.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol AYContentViewDelegate: AnyObject {
    
    func contentView(_ contentView: AYContentView, targetIndex: Int)
    func contentView(_ contentView: AYContentView, targetIndex: Int, progress: CGFloat)
}

class AYContentView: UIView {
    
    weak var delegate: AYContentViewDelegate?
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parsentVc: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScroll: Bool = false
    
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
        collectionView.delegate = self
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
        isForbidScroll = true
        let indexPath = IndexPath.init(row: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}


extension AYContentView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    private func contentEndScroll() {
        guard !isForbidScroll else { return }
        
        let cuttentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, targetIndex: cuttentIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else { return }
        var targetIndex = 0
        var progress: CGFloat = 0
        
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x {//左滑动
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
            
        } else {
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
}
