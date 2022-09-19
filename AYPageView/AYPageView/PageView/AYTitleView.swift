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
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = style.scrollLineColor
        bottomLine.frame.size.height = style.scrollLineHeight
        bottomLine.frame.origin.y = self.frame.height - style.scrollLineHeight
        return bottomLine
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
        
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
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
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                } else {
                    let preLabel  = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
                
            } else {
                w = bounds.width / CGFloat(count)
                x = CGFloat(i) * w
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
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
       
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        if self.style.isShowScrollLine {
            UIView.animate(withDuration: 0.15) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    
    
    private func adjustTitleLabel(targetIndex: Int) {
        
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        
        currentIndex = targetIndex
        
        if style.isScrollEnable {
            var offset = targetLabel.center.x - scrollView.bounds.width / 2
            
            if offset < 0 {
                offset = 0
            }
            if offset > (scrollView.contentSize.width - scrollView.bounds.width) {
                offset = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }

}


extension AYTitleView: AYContentViewDelegate {
    
    func contentView(_ contentView: AYContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    
    func contentView(_ contentView: AYContentView, targetIndex: Int, progress: CGFloat) {
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        let detalRGB =  UIColor.getRGBDelta(style.selectedColor, style.normalColor)
        let selectRGB = style.selectedColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        targetLabel.textColor = UIColor(r: normalRGB.0 + detalRGB.0 * progress, g: normalRGB.1 + detalRGB.1 * progress, b: normalRGB.2 + detalRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - detalRGB.0 * progress, g: selectRGB.1 - detalRGB.1 * progress, b: selectRGB.2 - detalRGB.2 * progress)
   
        if style.isShowScrollLine {
            let detalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let detalW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + detalX * progress
            bottomLine.frame.size.width = sourceLabel.frame.size.width + detalW * progress
        }
    
        print("target---\(targetIndex)---progress---\(progress)")
    }
    
 
    
}
