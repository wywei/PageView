//
//  AYPageView.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit



class AYPageView: UIView {

    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parsentVc: UIViewController
    fileprivate var style: AYTitleStyle
    
    fileprivate lazy var titleView: AYTitleView = {
        var titleView = AYTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: style.titleHeight), titles: titles, style: style)
        titleView.backgroundColor = .yellow
        return titleView
    }()
    
    fileprivate lazy var contentView: AYContentView = {
        var contentViewFrame = CGRect(x: 0, y: style.titleHeight, width: self.bounds.width, height: self.bounds.height - style.titleHeight)
        var contentView = AYContentView(frame: contentViewFrame, childVcs: childVcs, parsentVc: parsentVc)
        contentView.backgroundColor = .blue
        return contentView
    }()
    
    init(frame: CGRect, titles: [String], childvcs: [UIViewController], parsentVc: UIViewController, style: AYTitleStyle) {
        self.titles = titles
        self.childVcs = childvcs
        self.parsentVc = parsentVc
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension AYPageView {
    
    fileprivate func setupUI() {
        // titleView
        addSubview(titleView)
        
        // pageContentView
        addSubview(contentView)
        titleView.delegate = contentView
        contentView.delegate = titleView
        
    }

}
