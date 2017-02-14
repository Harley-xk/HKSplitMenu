//
//  ViewController.swift
//  HKSplitMenu
//
//  Created by harley.gb@foxmail.com on 02/13/2017.
//  Copyright (c) 2017 harley.gb@foxmail.com. All rights reserved.
//

import UIKit
import HKSplitMenu
import Comet

class ViewController: HKSplitMenu {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barTintColor = UIColor(red: 0.204, green: 0.588, blue: 0.831, alpha: 1)
        UINavigationBar.customizeAppearenceColorWith(barTint: barTintColor, foreground: .white)
        
        menu = MenuViewController.fromSB()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

