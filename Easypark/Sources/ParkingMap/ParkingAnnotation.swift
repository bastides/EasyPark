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

    let idObject: String
    let title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(idObject: String, name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.idObject = idObject
        self.title = name
        self.address = address
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
    class func fromEquipment(equipment: Equipment) -> ParkingAnnotation? {
        let idObject = equipment.id_obj ?? "No IdObject"
        let name = equipment.name ?? "No name"
        let address = equipment.address ?? "No address"
        let coordinate = CLLocationCoordinate2D(latitude: equipment.latitude, longitude: equipment.longitude)

        return ParkingAnnotation(idObject: idObject, name: name, address: address, coordinate: coordinate)
    }
    
    func pinTintColor() -> UIColor  {
        let parking = Parking.parkingForIdObj(idObject: self.idObject, moc: CoreDataStack.sharedInstance.managedObjectContext!)
        let currentPlaces = Int(parking?.available ?? "0")
        let totalPlaces = Int(parking?.exploitation ?? "0")
        var currentPlacesRate = 0
        if currentPlaces != 0 {
            currentPlacesRate = (currentPlaces! * 100) / totalPlaces!
        }
        
        switch currentPlacesRate {
        case 20...100:
            return Constants.ColorPalette.pinColorGreen
        case 5..<20:
            return Constants.ColorPalette.pinColorOrange
        case 0..<5:
            return Constants.ColorPalette.pinColorRed
        default:
            return Constants.ColorPalette.pinColorWhite
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }

}
