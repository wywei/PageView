//
//  ViewController.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

fileprivate let kPageCollectionViewCell = "kPageCollectionViewCell"

class ViewController: UIViewController {
  
    lazy var pageView: AYPageView = {
        let titles = ["首页","首页首页首页首页","首页","首页","首页","首页","首页","首页","首页","首页","首页"]
        var childVcs: [UIViewController] = []
        
        for i in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.arc4randomColor()
            childVcs.append(vc)
        }
        
        let style = AYTitleStyle()
        style.titleHeight = 64
        style.isScrollEnable = true
        style.isShowScrollLine = true
        let pageViewFrame = CGRect(x: 0, y: kNavigationBarH, width: self.view.frame.width, height:  self.view.frame.height - kNavigationBarH)
        var pageView = AYPageView(frame: pageViewFrame,
                                  titles: titles,
                                  childvcs: childVcs,
                                  parsentVc: self,
                                  style: style)
        pageView.backgroundColor = .red
        return pageView
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        let titles = ["首页","首页首页首页首页","首页","首页","首页","首页","首页","首页","首页"]
        let style = AYTitleStyle()
        style.isShowScrollLine = true
        style.isScrollEnable = true
        
        let layout = AYPageCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.rows = 7
        layout.cols = 4
        
        let pageCollectionView = AYPageCollectionView(frame: pageFrame, titles: titles, isTitleInTop: true, style: style, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.register(UICollectionViewCell.self, kPageCollectionViewCell)
        view.addSubview(pageCollectionView)
        
    }

}


extension ViewController: AYPageCollectionViewDelegate {
    func numberOfSections(in pageCollectionView: AYPageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: AYPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(arc4random_uniform(30)) + 100
    }
    
    func pageCollectionView(_ pageCollectionView: AYPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageCollectionViewCell, for: indexPath)
        return cell
    }
    
}
