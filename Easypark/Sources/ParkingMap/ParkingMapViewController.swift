//
//  ParkingMapViewController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 17/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import MapKit
import EasyparkModel

class ParkingMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Var & outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    var parkingMapConfiguration: ParkingMapConfiguration?
    
    var locationManager = CLLocationManager()
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parkingMapConfiguration = ParkingMapConfiguration(mapView: self.mapView)
        self.parkingMapConfiguration?.loadData()
        mapView.delegate = self
        
        self.title = Constants.MapViewInfos.TITLE
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    // MARK: - location manager to authorize user location for Maps app
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
        let parkingInfosViewController = ParkingInfosViewController(parking: parkingAnnotation.parking)
        self.navigationController?.pushViewController(parkingInfosViewController, animated: true)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


