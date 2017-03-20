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
    
    @IBOutlet weak var imageStatus: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    @IBOutlet var availablePlacesLabel: UILabel!
    
    private let placeTitle = "Places"
    
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeTitleLabel.text = self.placeTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func setImageStatusWith(availablePlaces: String, exploitationPlaces: String) {
        let currentPlaces = Int(availablePlaces) ?? 0
        let totalPlaces = Int(exploitationPlaces) ?? 0
        var currentPlacesRate = 0
        if currentPlaces != 0 {
            currentPlacesRate = (currentPlaces * 100) / totalPlaces
        }
        
        switch currentPlacesRate {
        case 20...100:
            self.imageStatus.image = Constants.Images.parkingEmpty
        case 5..<20:
            self.imageStatus.image = Constants.Images.parkingAlmostFull
        case 0..<5:
            self.imageStatus.image = Constants.Images.parkingFull
        default:
            break
        }
    }
    
    internal func setNameLabelWith(name: String) {
        self.nameLabel.text = name
    }
    
    internal func setAvailableLabelWith(availablePlaces: String) {
        self.availablePlacesLabel.text = availablePlaces
    }
}
