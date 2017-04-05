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

class ParkingMapViewController: UIViewController, ParkingSelectAblePin {
    
    // MARK: - Var & outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    var parkingMapConfiguration: ParkingMapConfiguration?
    
    var locationManager = CLLocationManager()
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parkingMapConfiguration = ParkingMapConfiguration(mapView: self.mapView)
        self.parkingMapConfiguration?.loadData()
        
        self.parkingMapConfiguration?.pinDelegate = self
        
        self.title = Constants.MapViewInfos.TITLE
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    // MARK: - location manager to authorize user location for Maps app
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // MARK: - ParkingSelectAblePin
    
    func didSelectParkingPin(parking: Parking) {
        let parkingInfosViewController = ParkingInfosViewController(parking: parking)
        self.navigationController?.pushViewController(parkingInfosViewController, animated: true)
    }
}


