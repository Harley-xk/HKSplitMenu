//
//  MenuItem.swift
//  HKSplitMenu
//
//  Created by Harley on 2017/2/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper

class MenuGroup: Model {
    var headerHeight: CGFloat = 0
    var items: [MenuItem] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        items <- map["items"]
    }
}

class MenuItem: Model {
    var title: String = ""
    var iconName: String = ""
    var sbName: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        iconName <- map["icon"]
        sbName <- map["storyBorad"]
    }
}
