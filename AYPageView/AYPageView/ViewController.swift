//
//  ViewController.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var pageView: AYPageView = {
        let titles = ["首页","首页首页首页首页","首页","首页","首页","首页","首页","首页","首页","首页","首页"]
        var childVcs: [UIViewController] = []
        
        for i in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = i % 2 == 0 ? .blue : .red
            childVcs.append(vc)
        }
        
        let style = AYTitleStyle()
        style.titleHeight = 64
        style.isScrollEnable = true
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
        
        setupUI()
    }

}


extension ViewController {

    fileprivate func setupUI() {
        view.addSubview(pageView)
        
    }

}

