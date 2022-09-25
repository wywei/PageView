//
//  AYPageCollectionView.swift
//  AYPageView
//
//  Created by Andy on 2022/9/22.
//

import UIKit

protocol AYPageCollectionViewDelegate: AnyObject {
    func numberOfSections(in pageCollectionView: AYPageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView: AYPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: AYPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

fileprivate let kContentCell = "kContentCell"

public class AYPageCollectionView: UIView {

    weak var dataSource: AYPageCollectionViewDelegate?
    fileprivate var titles: [String]
    fileprivate var isTitleInTop: Bool
    fileprivate var layout: UICollectionViewFlowLayout
    fileprivate var style: AYTitleStyle
    var collectionView: UICollectionView!
    
    init(frame: CGRect,
         titles: [String],
         isTitleInTop: Bool = false,
         style: AYTitleStyle,
         layout: UICollectionViewFlowLayout) {
        
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}


extension AYPageCollectionView {
    
    fileprivate func setupUI() {
        // titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        let titleView = AYTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.backgroundColor = .purple
        
        // pageCotroll
        let pageControlHeight: CGFloat = 20
        let pageControlY: CGFloat = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        pageControl.backgroundColor = .blue
        
        let collectionViewY: CGFloat = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - pageControlHeight - style.titleHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.arc4randomColor()
       }

}

// MARK:- 对外暴漏
public extension AYPageCollectionView {
    func register(_ cell: AnyClass, _ identifier: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ nib: UINib, _ identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

}



extension AYPageCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.pageCollectionView(self, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dataSource!.pageCollectionView(self, collectionView: collectionView, cellForItemAt: indexPath)
        cell.backgroundColor = UIColor.arc4randomColor()
        return cell
    }
    
}
