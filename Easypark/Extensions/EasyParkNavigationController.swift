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

        self.navigationBar.barTintColor = Constants.ColorPalette.NAVIGATION_BAR_TINT
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.ColorPalette.NAVIGATION_BAR_TITLE]
        self.navigationBar.tintColor = Constants.ColorPalette.NAVIGATION_BAR_TITLE
    }

}
