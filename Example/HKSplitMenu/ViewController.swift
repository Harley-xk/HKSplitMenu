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
        
        menu = MenuViewController.fromSB()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

