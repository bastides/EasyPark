//
//  ParkingMapConfiguration.swift
//  Easypark
//
//  Created by Sebastien Bastide on 20/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import MapKit
import EasyparkModel

class ParkingMapConfiguration: NSObject {

    // MARK: - Var & outlet
    
    private let mapView: MKMapView
    
    let regionRadius = CLLocationDistance(Constants.MapInfos.regionRadius)
    
    var parkingAnnotations = [ParkingAnnotation]()
    
    let parkingsIdObjectArray = StorageManager.sharedInstance.fetchAllParkingsIdObj(managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext!)
    
    internal init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
    }
    
    
    // MARK: - Data Processing
    
    func loadData() {
        let initialLocation = CLLocation(latitude: Constants.MapInfos.nantesLatutide, longitude: Constants.MapInfos.nantesLongitude)
        centerMapOnLocation(initialLocation)
        
        initializationData()
        mapView.addAnnotations(parkingAnnotations)
    }

    func initializationData() {
        for position in 0..<parkingsIdObjectArray.count {
            let equipment = Equipment.equipmentForIdObj(idObject: parkingsIdObjectArray[position], moc: CoreDataStack.sharedInstance.managedObjectContext!)
            if equipment != nil {
                guard let parkingAnnotation = ParkingAnnotation.fromEquipment(equipment: equipment!) else {
                    return
                }
                parkingAnnotations.append(parkingAnnotation)
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}