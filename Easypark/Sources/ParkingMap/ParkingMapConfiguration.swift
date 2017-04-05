//
//  ParkingMapConfiguration.swift
//  Easypark
//
//  Created by Sebastien Bastide on 20/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import EasyparkModel

protocol ParkingSelectAblePin {
    func didSelectParkingPin(parking: Parking)
}

class ParkingMapConfiguration: NSObject, MKMapViewDelegate {

    // MARK: - Var & outlet
    
    private let mapView: MKMapView
    
    private let regionRadius = CLLocationDistance(Constants.MapViewInfos.REGION_RADIUS)
    
    private var parkingAnnotations = [ParkingAnnotation]()
    
    public var pinDelegate: ParkingSelectAblePin?
    
    internal init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        self.mapView.delegate = self
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
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkingAnnotation {
            let identifier = "parkingPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.pinTintColor = annotation.pinTintColor()
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let parkingAnnotation = view.annotation as! ParkingAnnotation
        self.pinDelegate?.didSelectParkingPin(parking: parkingAnnotation.parking)
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! ParkingAnnotation
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
//
//        print("coucou")
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didselect")
    }
}
