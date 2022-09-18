//
//  AYTitleView.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

protocol AYTitleViewDelegate: AnyObject {
    func titleView(_ titleView: AYTitleView, targetIndex: Int)
}


class AYTitleView: UIView {

    weak var delegate: AYTitleViewDelegate?
    fileprivate var titles: [String]
    fileprivate var style: AYTitleStyle
    fileprivate var titleLabels:[UILabel] = []
    fileprivate lazy var currentIndex: Int = 0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()

    init(frame: CGRect, titles: [String], style: AYTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension AYTitleView {
    
    fileprivate func setupUI() {
        addSubview(scrollView)
        
        setupTitleLabel()
        
        setupLabelFrame()
    }
    
    private func setupTitleLabel() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            label.tag = index
            label.textAlignment = .center
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_ :)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }
    }

    private func setupLabelFrame() {
        let count = titles.count
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable {
                
               w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : label.font], context: nil).width
                if i == 0 {
                    x  = style.itemMargin * 0.5
                } else {
                    let preLabel  = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
                
            } else {
                w = bounds.width / CGFloat(count)
                x = CGFloat(i) * w
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        let lastLabel = titleLabels.last!
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: lastLabel.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK:- 监听事件

extension AYTitleView {
    
    @objc fileprivate func labelClicked(_ tap: UITapGestureRecognizer) {
        
        let targetLabel = tap.view as! UILabel
        let sourceLabel = titleLabels[currentIndex]
        
        targetLabel.textColor = style.selectedColor
        sourceLabel.textColor = style.normalColor
        
        currentIndex = targetLabel.tag
        
        delegate?.titleView(self, targetIndex: currentIndex)
        
        if style.isScrollEnable {
            var offset = targetLabel.center.x - scrollView.bounds.width / 2
            
            if offset < 0 {
                offset = 0
            }

            if offset > (scrollView.contentSize.width - scrollView.bounds.width) {
                offset = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            
        } else {
            
        }
        
    }
}

