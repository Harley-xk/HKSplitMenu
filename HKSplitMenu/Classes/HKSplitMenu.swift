//
//  HKSplitMenu.swift
//  Docs.M
//
//  Created by Harley on 2017/2/13.
//  Copyright © 2017年 Harley. All rights reserved.
//

import UIKit


open class HKSplitMenu: UIViewController {
    
    // 菜单栏的宽度，默认 64
    open var menuWidth: CGFloat = 64 {
        didSet{
            menuWidthConstraint?.constant = menuWidth
            contentLeftConstraint?.constant = menuWidth
            view.layoutIfNeeded()
        }
    }
    
    open var menu: UIViewController? {
        willSet {
            menu?.view.removeFromSuperview()
            menu?.removeFromParentViewController()
        }
        didSet {
            setupMenu()
        }
    }
    
    open var content: UIViewController? {
        return currentContent
    }
    
    
    /// 加载内容视图，替换当前内容视图
    ///
    /// - Parameters:
    ///   - identifier: 内容视图识别位，设置了 identifier，该内容视图将会被缓存
    ///   - provider: 提供内容视图的闭包，如果对应 identifier 的视图控制器尚未缓存，则会调用 provider 获得新的内容视图并缓存，反之，除非强制更新，否则使用已缓存的内容视图
    ///   - forceUpdate: 强制更新，如果设置为 true，则不论是否已存在缓存，都会调用 provider 获得新的内容视图，并更新缓存
    open func setContent(for identifier: String, forceUpdate: Bool = false, provider: () -> (UIViewController)) {
     
        var newContent = cachedContent(for: identifier)
        if forceUpdate || newContent == nil {
            newContent = provider()
            cacheContent(newContent!, for: identifier)
        }
        updateContent(with: newContent!)
    }
    
    /// 加载内容视图，并且不缓存
    open func setContent(_ content: UIViewController) {
        updateContent(with: content)
    }
    
    // MARK: - Private
    private weak var menuContainer: UIView!
    private weak var menuWidthConstraint: NSLayoutConstraint!

    private weak var contentContainer: UIView!
    private weak var contentLeftConstraint: NSLayoutConstraint!
    
    private var currentContent: UIViewController?
    private var cachedContentViewControllers: [String : UIViewController] = [:]
    
    // 加载视图
    override open func loadView() {
        super.loadView()
        
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupMenuContainer()
        setupContentContainer()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Caches
    private func cachedContent(for identifier: String) -> UIViewController? {
        return cachedContentViewControllers[identifier]
    }
    
    /// 缓存视图，不加载，会替换已缓存的视图
    open func cacheContent(_ content: UIViewController, for identifier: String) {
        cachedContentViewControllers[identifier] = content
    }

    // MARK: - AutoLayout
    private func setupMenuContainer() {
        
        let leftView = UIView(forAutoLayout: true)
        view.addSubview(leftView)
        menuContainer = leftView
        
        let leftC = NSLayoutConstraint(item: menuContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: menuContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: menuContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let widthC = NSLayoutConstraint(item: menuContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: menuWidth)
        menuWidthConstraint = widthC
        
        view.addConstraints([leftC, topC, bottomC, widthC])
        view.layoutIfNeeded()
    }
    
    private func setupContentContainer() {
        
        let contentView = UIView(forAutoLayout: true)
        view.addSubview(contentView)
        contentContainer = contentView
        
        let leftC = NSLayoutConstraint(item: contentContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: menuWidth)
        let topC = NSLayoutConstraint(item: contentContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: contentContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let rightC = NSLayoutConstraint(item: contentContainer, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        contentLeftConstraint = leftC
        
        view.addConstraints([leftC, topC, bottomC, rightC])
        view.layoutIfNeeded()
    }
    
    private func setupMenu() {
        
        if let menuView = menu?.view {
            
            menuView.translatesAutoresizingMaskIntoConstraints = false
            menuContainer.addSubview(menuView)
            addChildViewController(menu!)
            
            let leftC = NSLayoutConstraint(item: menuView, attribute: .left, relatedBy: .equal, toItem: menuContainer, attribute: .left, multiplier: 1, constant: 0)
            let topC = NSLayoutConstraint(item: menuView, attribute: .top, relatedBy: .equal, toItem: menuContainer, attribute: .top, multiplier: 1, constant: 0)
            let bottomC = NSLayoutConstraint(item: menuView, attribute: .bottom, relatedBy: .equal, toItem: menuContainer, attribute: .bottom, multiplier: 1, constant: 0)
            let rightC = NSLayoutConstraint(item: menuView, attribute: .right, relatedBy: .equal, toItem: menuContainer, attribute: .right, multiplier: 1, constant: 0)
            
            menuContainer.addConstraints([leftC, topC, bottomC, rightC])
            view.layoutIfNeeded()
        }
    }
    
    private func updateContent(with new: UIViewController) {
        
        if currentContent == new {
            return
        }
        currentContent?.view.removeFromSuperview()
        currentContent?.removeFromParentViewController()

        addChildViewController(new)
        new.view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(new.view)
        
        let leftC = NSLayoutConstraint(item: new.view, attribute: .left, relatedBy: .equal, toItem: contentContainer, attribute: .left, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: new.view, attribute: .top, relatedBy: .equal, toItem: contentContainer, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: new.view, attribute: .bottom, relatedBy: .equal, toItem: contentContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let rightC = NSLayoutConstraint(item: new.view, attribute: .right, relatedBy: .equal, toItem: contentContainer, attribute: .right, multiplier: 1, constant: 0)

        contentContainer.addConstraints([leftC, topC, bottomC, rightC])
        currentContent = new
        view.layoutIfNeeded()
    }

}

extension UIView {
    fileprivate convenience init(forAutoLayout: Bool) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }
}

public extension UIViewController {
    public var splitMenu: HKSplitMenu? {
        if parent is HKSplitMenu {
            return parent as! HKSplitMenu
        }
        return nil
    }
}


