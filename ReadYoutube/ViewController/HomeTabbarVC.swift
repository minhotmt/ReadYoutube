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
        setupTabbar()
    }
    
    func setupTabbar() {
        let firstViewController = SecondVC()
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_home"), tag: 0)
        let secondViewController = HomeVC()
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_fire"), tag: 1)
        let profileViewController = ProfileVC()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_profile"), tag: 2)
        let libraryVC = LibraryVC()
        libraryVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_notebook"), tag: 3)
        let tabBarList = [firstViewController, secondViewController, libraryVC, profileViewController]
        viewControllers = tabBarList
    }
    
}
