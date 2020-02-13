//
//  HomeTabbarVC.swift
//  ReadYoutube
//
//  Created by MinhNV-GD on 2/5/20.
//  Copyright © 2020 MinhNV-GD. All rights reserved.
//

import UIKit

class HomeTabbarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTabbar()
    }
    
    func setupTabbar() {
        let firstViewController = HomeVC()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let secondViewController = SecondVC()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        let profileViewController = ProfileVC()
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 2)
        let tabBarList = [firstViewController, secondViewController, profileViewController]
        viewControllers = tabBarList
    }
    
}
