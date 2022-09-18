//
//  Common.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit


let kStateBarH: CGFloat = isIphoneXS() ? 24 : 0
let kNavigationBarH: CGFloat  = isIphoneXS() ? 88 : 64
let kTabH: CGFloat = isIphoneXS() ? 34 : 0 // 圆角部分的高度
let kTabBarH: CGFloat = isIphoneXS() ? 83 : 49




func isIphoneXS() -> Bool {
    var isIphoneX = false
    if UIDevice.current.userInterfaceIdiom == .phone {
        if #available(iOS 11.0, *) {
            isIphoneX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0.0
        }
    }
    return isIphoneX
}



