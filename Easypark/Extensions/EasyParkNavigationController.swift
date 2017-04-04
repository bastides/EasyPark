//
//  EasyParkNavigationController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 29/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit

class EasyParkNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = Constants.ColorPalette.navigationBarTintColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.ColorPalette.navigationBarTitleColor]
        self.navigationBar.tintColor = Constants.ColorPalette.navigationBarTitleColor
    }

}
