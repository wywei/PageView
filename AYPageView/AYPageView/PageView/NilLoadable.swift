//
//  NilLoadable.swift
//  AYPageView
//
//  Created by Andy on 2022/9/21.
//

import UIKit

protocol NilLoadable { }

extension NilLoadable where Self : UIView {
    static func loadFromNib(nibName: String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}


