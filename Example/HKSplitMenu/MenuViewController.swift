//
//  MenuViewController.swift
//  HKSplitMenu
//
//  Created by Harley on 2017/2/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import Comet
import ObjectMapper

class MenuViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var groups: [MenuGroup] = []
    var currentItem: MenuItem? {
        didSet {
            if currentItem != nil {
                splitMenu?.setContent(for: currentItem!.title, provider: { () -> (UIViewController) in
                    let content = ContentViewController.fromSB()
                    content.title = currentItem!.title
                    let nav = UINavigationController(rootViewController: content)
                    return nav
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuItems()
        currentItem = groups[0].items[0]
    }

    private func setupMenuItems() {
        let path = Bundle.main.resource("Menu.plist")!
        let dict = NSDictionary(contentsOfFile: path.string)
        if let array = dict?.object(forKey: "Groups") as? [[String:Any]] {
            if let result =  Mapper<MenuGroup>().mapArray(JSONArray: array) {
                groups = result
            }
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return groups[section].hederHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let item = groups[indexPath.section].items[indexPath.row]
        cell.load(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentItem = groups[indexPath.section].items[indexPath.row]
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

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    func load(_ item: MenuItem, selected: Bool = false) {
        iconView.image = UIImage(named: "menu_\(item.iconName)")
        titleLabel.text = item.title
        
        colorView.backgroundColor = selected ? MenuSelectedColor : MenuDefaultColor;
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        highlightView.backgroundColor = highlighted ?  MenuHighlightedColor : .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        colorView.backgroundColor = selected ? MenuSelectedColor : MenuDefaultColor;
    }
}

let MenuDefaultColor = UIColor(red: 0.137, green: 0.149, blue: 0.173, alpha: 1.000)
let MenuSelectedColor = UIColor(red: 0.204, green: 0.588, blue: 0.831, alpha: 1.000)
let MenuHighlightedColor = UIColor(red: 0.204, green: 0.588, blue: 0.831, alpha: 0.7)


