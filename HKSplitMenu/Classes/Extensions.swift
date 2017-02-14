//
//  Extensions.swift
//  Pods
//
//  Created by Harley on 2017/2/14.
//
//

import Foundation

extension UIView {
    internal convenience init(forAutoLayout: Bool) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }
}

public extension UIViewController {
    
    /// 获取当前视图的分栏菜单，不存在则返回 nil
    public var splitMenu: HKSplitMenu? {
        var vc = parent
        while vc != nil {
            if vc is HKSplitMenu {
                return vc as! HKSplitMenu
            } else {
                vc = vc?.parent
            }
        }
        return nil
    }
}

