//
//  EasyParkTabBarController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 29/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit

class EasyParkTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = Constants.ColorPalette.tabBarTintColor
        self.tabBar.tintColor = Constants.ColorPalette.tabBarItemSelected
        
        for item in self.tabBar.items! {
            let unselctedItem = [NSForegroundColorAttributeName: Constants.ColorPalette.tabBarItemDefault]
            let selectedItem = [NSForegroundColorAttributeName: Constants.ColorPalette.tabBarItemSelected]
            
            item.setTitleTextAttributes(unselctedItem, for: .normal)
            item.setTitleTextAttributes(selectedItem, for: .selected)
        }
    }
}
