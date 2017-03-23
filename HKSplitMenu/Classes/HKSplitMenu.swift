//
//  HKSplitMenu.swift
//  Docs.M
//
//  Created by Harley on 2017/2/13.
//  Copyright © 2017年 Harley. All rights reserved.
//

import UIKit


open class HKSplitMenu: UIViewController, UIGestureRecognizerDelegate {
    
    // 菜单栏的宽度，默认 64
    open var menuWidth: CGFloat = 64 {
        didSet{
            menuWidthConstraint?.constant = menuWidth
            contentLeftConstraint?.constant = menuWidth
            view.layoutIfNeeded()
        }
    }
    
    // 菜单视图
    open var menu: UIViewController? {
        willSet {
            menu?.view.removeFromSuperview()
            menu?.removeFromParentViewController()
        }
        didSet {
            setupMenu()
        }
    }
    
    // 内容视图
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
    
    
    /// 打开或者关闭菜单，锁定菜单时无效
    open func toggleMenu() {
        if isMenuFixed { return }
        
        if isMenuShown { hideMenu() }
        else { showMenu() }
    }
    
    /// 加载内容视图，并且不缓存
    open func setContent(_ content: UIViewController) {
        updateContent(with: content)
    }
    
    /// 是否锁定菜单，菜单锁定后无法隐藏
    open var isMenuFixed: Bool {
        return fixedMenu
    }
    
    /// 菜单是否显示
    open var isMenuShown: Bool {
        return menuShown
    }

    // MARK: - Private
    private weak var menuContainer: UIView!
    private weak var menuWidthConstraint: NSLayoutConstraint!

    private weak var contentContainer: UIView!
    private weak var contentLeftConstraint: NSLayoutConstraint!
    
    private var currentContent: UIViewController?
    private var cachedContentViewControllers: [String : UIViewController] = [:]
    
    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    private var fixedMenu = false {
        didSet {
            updateLayout()
        }
    }

    private var menuShown = false
    
    private var shouldFixMenu: Bool {
        return traitCollection.horizontalSizeClass == .regular
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        setupMenuContainer()
        setupContentContainer()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        fixedMenu = shouldFixMenu
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

    
    // MARK: - Layouts
    private func updateLayout() {
        
        contentLeftConstraint.constant = isMenuFixed ? menuWidth : 0
        menuShown = isMenuFixed

        panGesture.isEnabled = !isMenuFixed
        tapGesture.isEnabled = false
        
        let identityTransform = CGAffineTransform.identity
        contentContainer.transform = identityTransform
        contentContainer.isUserInteractionEnabled = true
        
        view.layoutIfNeeded()
    }
    
    open func showMenu() {
        if isMenuFixed { return }

        menuShown = true
        tapGesture.isEnabled = true
        contentContainer.isUserInteractionEnabled = false
        
        let identity = CGAffineTransform.identity
        UIView.animate(withDuration: 0.15) {
            self.contentContainer.transform = identity.translatedBy(x: self.menuWidth, y: 0)
        }
    }
    
    @objc open func hideMenu() {
        
        if isMenuFixed { return }

        menuShown = false
        tapGesture.isEnabled = false
        contentContainer.isUserInteractionEnabled = true
        
        let identity = CGAffineTransform.identity
        UIView.animate(withDuration: 0.15) {
            self.contentContainer.transform = identity
        }
    }
    
    // MARK: - SizeClass
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        menu?.willTransition(to: newCollection, with: coordinator)
        currentContent?.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.fixedMenu = newCollection.horizontalSizeClass == .regular
        }, completion: nil)
    }
    
    // MARK: - Gesture
    /// 从屏幕边缘侧滑可以开启菜单，这个参数设置响应侧滑手势的宽度范围
    open var panGestureEdge: CGFloat = 30
    /// 内容视图向右最大滑动距离
    open var panGestureMaxOffset: CGFloat = 200
    
    /// 侧滑手势起点
    private var panGestureStartX: CGFloat = 0
 
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGesture {
            let point = touch.location(in: view)
            return !menuContainer.frame.contains(point)
        }
        if gestureRecognizer == panGesture {
            let point = touch.location(in: contentContainer)
            return (point.x <= panGestureEdge || isMenuShown)
        }
        return true
    }
    
    @objc private func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: view)
        var delta = point.x - panGestureStartX

        if gesture.state == .began {
            panGestureStartX = point.x
        }
        else if gesture.state == .changed {
            if panGestureStartX > panGestureEdge && !isMenuShown {
                return
            }
            if isMenuShown {
                delta += menuWidth
            }
            delta = max(0, delta)
            if delta > menuWidth {
                delta = panGestureMaxOffset - (menuWidth * (panGestureMaxOffset - menuWidth) / delta)
            }
            
            let identity = CGAffineTransform.identity
            contentContainer.transform = identity.translatedBy(x: delta, y: 0)
        }
        else {
            
            if panGestureStartX > panGestureEdge && !isMenuShown {
                panGestureStartX = 0
                return
            }
            
            if delta >= menuWidth {
                showMenu()
            } else {
                hideMenu()
            }
        }        
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
        
        if menu != nil {
            
            addChildViewController(menu!)
            
            let menuView = menu!.view!
            menuView.translatesAutoresizingMaskIntoConstraints = false
            menuContainer.addSubview(menuView)

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


