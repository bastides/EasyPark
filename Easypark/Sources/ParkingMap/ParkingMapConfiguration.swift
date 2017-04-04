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
    
    let regionRadius = CLLocationDistance(Constants.MapViewInfos.REGION_RADIUS)
    
    var parkingAnnotations = [ParkingAnnotation]()
    
    internal init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
    }
    
    
    // MARK: - Data Processing
    
    func loadData() {
        let initialLocation = CLLocation(latitude: Constants.MapViewInfos.NANTES_LATITUDE, longitude: Constants.MapViewInfos.NANTES_LONGITUDE)
        centerMapOnLocation(initialLocation)
        
        initializationData()
        mapView.addAnnotations(parkingAnnotations)
    }
    
    func initializationData() {
        guard let moc = CoreDataStack.sharedInstance.managedObjectContext else { return }
        guard let parkingArray = Parking.allParkings(moc: moc) else { return }
        for parking in parkingArray {
            if parking.equipment != nil {
                guard let parkingAnnotation = ParkingAnnotation.fromParking(parking: parking) else { return }
                parkingAnnotations.append(parkingAnnotation)
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
