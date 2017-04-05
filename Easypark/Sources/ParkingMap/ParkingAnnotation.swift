//
//  ParkingAnnotation.swift
//  Easypark
//
//  Created by Sebastien Bastide on 18/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import EasyparkModel
import MapKit
import Contacts

class ParkingAnnotation: NSObject, MKAnnotation {

    let parking: Parking
    let title: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    
    init(parking: Parking, name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.parking = parking
        self.title = name
        self.address = address
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
    class func fromParking(parking: Parking) -> ParkingAnnotation? {
        guard let equipment = parking.equipment else { return nil }
        let name = equipment.name ?? "No name"
        let address = equipment.address ?? "No address"
        let coordinate = CLLocationCoordinate2D(latitude: equipment.latitude, longitude: equipment.longitude)

        return ParkingAnnotation(parking: parking, name: name, address: address, coordinate: coordinate)
    }
    
    func pinTintColor() -> UIColor  {
        var isOpen: Bool?
        guard let schedulesArray = self.parking.schedules.allObjects as? [Schedules] else {
            return Constants.ColorPalette.PIN_WHITE
        }
        isOpen = SchedulesService.sharedInstance.parkingIsOpen(schedulesArray: schedulesArray, parkingStatus: parking.status ?? "0")
        switch isOpen {
        case true?:
            return Constants.ColorPalette.PIN_GREEN
        case false?:
            return Constants.ColorPalette.PIN_RED
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }

}
