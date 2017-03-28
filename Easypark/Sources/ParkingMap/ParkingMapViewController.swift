//
//  ParkingMapViewController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 17/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import MapKit

class ParkingMapViewController: UIViewController {
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


