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
    
    @IBOutlet weak var openStatusLabel: UILabel!
    
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
    
    
    // MARK: - Setter
    
    internal func setImageStatusWith() {
        self.imageStatus.image = Constants.Images.PARKING
    }
    
    internal func setNameLabelWith(name: String) {
        self.nameLabel.text = name
    }
    
    internal func setAvailableLabelWith(availablePlaces: String) {
        self.availablePlacesLabel.text = availablePlaces
    }
    
    internal func setOpenStatusLabelWith(isOpen: Bool?) {
        switch isOpen {
        case true?:
            self.openStatusLabel.text = Constants.ParkingStatus.PARKING_OPEN
            self.openStatusLabel.textColor = Constants.ColorPalette.PARKING_OPEN
        case false?:
            self.openStatusLabel.text = Constants.ParkingStatus.PARKING_CLOSED
            self.openStatusLabel.textColor = Constants.ColorPalette.PARKING_CLOSED
        default:
            self.openStatusLabel.text = ""
        }
    }
}
