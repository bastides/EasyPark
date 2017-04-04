//
//  ParkingInfosViewController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 30/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import EasyparkModel

class ParkingInfosViewController: UIViewController {
    
    // MARK: - Var & outlet
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var phoneNumberButton: UIButton!

    @IBOutlet weak var webButton: UIButton!
    
    @IBOutlet weak var openStatusLabel: UILabel!
    
    private let parking: Parking?
    
    var isOpen: Bool? = nil
    
    private let parkingOpen = "Open"
    
    private let parkingClosed = "Closed"
    
    
    // MARK: - View life cycle
    
    init(parking: Parking) {
        self.parking = parking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if parking != nil {
            guard let equipment = parking?.equipment else {
                setAllDefaultValue()
                return
            }
            self.setNameLabelWith(name: equipment.name ?? "Name unavailable")
            self.setAddressLabelWith(address: equipment.address ?? "Address unavailable")
            self.setPostalCodeWith(postalCode: equipment.postal_code ?? "Postal code unavailable")
            self.setCityLabelWith(city: equipment.city ?? "City unavailable")
            self.setPhoneNumberButtonTitleWith(phoneNumber: equipment.phone_number ?? "Phone number unavailable")
            self.setWebButtonTitleWith(web: equipment.web ?? "Website unavailable")
            guard let schedulesArray = parking?.schedules.allObjects as? [Schedules], schedulesArray != [] else {
                self.setOpenStatusLabelWith(isOpen: isOpen)
                return
            }
            isOpen = SchedulesService.sharedInstance.parkingIsOpen(schedulesArray: schedulesArray, parkingStatus: parking?.status ?? "0")
            self.setOpenStatusLabelWith(isOpen: isOpen)
        }
    }
    
    
    // MARK: - View

    @IBAction func pressPhoneNumberButton(_ sender: UIButton) {
        self.callPhoneNumber(phoneNumber: sender.titleLabel?.text ?? "02 40 41 90 00")
    }
    
    @IBAction func pressWebButton(_ sender: UIButton) {
        self.callWebsite(url: sender.titleLabel?.text ?? "www.parkings-nantes.fr")
    }
    
    private func callPhoneNumber(phoneNumber: String) {
        let phone = phoneNumber.replacingOccurrences(of: " ", with: "")
        let urlRequest = "telprompt://" + phone
        guard let url = URL(string: urlRequest) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func callWebsite(url: String) {
        let urlRequest = "http://" + url
        guard let url = URL(string: urlRequest) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: - Setter
    
    internal func setNameLabelWith(name: String) {
        self.nameLabel.text = name
        self.nameLabel.textColor = Constants.ColorPalette.navigationBarTintColor
    }
    
    internal func setAddressLabelWith(address: String) {
        self.addressLabel.text = address
    }
    
    internal func setPostalCodeWith(postalCode: String) {
        self.postalCodeLabel.text = postalCode
    }
    
    internal func setCityLabelWith(city: String) {
        self.cityLabel.text = city
    }
    
    internal func setPhoneNumberButtonTitleWith(phoneNumber: String) {
        self.phoneNumberButton.setTitle(phoneNumber, for: .normal)
    }
    
    internal func setWebButtonTitleWith(web: String) {
        self.webButton.setTitle(web, for: .normal)
    }
    
    internal func setOpenStatusLabelWith(isOpen: Bool?) {
        switch isOpen {
        case true?:
            self.openStatusLabel.text = parkingOpen
            self.openStatusLabel.textColor = Constants.ColorPalette.pinColorGreen
        case false?:
            self.openStatusLabel.text = parkingClosed
            self.openStatusLabel.textColor = Constants.ColorPalette.pinColorRed
        default:
            self.openStatusLabel.text = ""
        }
    }
    
    internal func setAllDefaultValue() {
        self.setNameLabelWith(name: self.parking?.name ?? "")
        self.setAddressLabelWith(address: "Address unavailable")
        self.addressLabel.textColor = UIColor.gray
        self.setPostalCodeWith(postalCode: "")
        self.setCityLabelWith(city: "")
        self.setPhoneNumberButtonTitleWith(phoneNumber: "Phone number unavailable")
        self.phoneNumberButton.isEnabled = false
        self.setWebButtonTitleWith(web: "Website unavailable")
        self.webButton.isEnabled = false
        self.setOpenStatusLabelWith(isOpen: nil)
    }
}
