//
//  ParkingTableViewCell.swift
//  Easypark
//
//  Created by Sebastien Bastide on 11/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {

    // MARK: - Var & outlet
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var availablePlacesLabel: UILabel!
    
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func setNameLabelWith(name: String) {
        self.nameLabel.text = name
    }
    
    internal func setAvailableLabelWith(availablePlaces: String) {
        self.availablePlacesLabel.text = availablePlaces
    }
}
