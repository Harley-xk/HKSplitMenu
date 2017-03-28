//
//  ContentViewController.swift
//  HKSplitMenu
//
//  Created by Harley on 2017/2/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateToggleItem(for: traitCollection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuAction(_ sender: Any) {
        splitMenu?.toggleMenu()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        updateToggleItem(for: newCollection)
    }
    
    func updateToggleItem(for traitCollection: UITraitCollection) {
        if traitCollection.horizontalSizeClass == .regular {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(menuAction(_:)))
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
