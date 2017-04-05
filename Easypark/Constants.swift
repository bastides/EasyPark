//
//  Constants.swift
//  Easypark
//
//  Created by Sebastien Bastide on 03/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: - API
    
    struct ApiInfos {
        static let API_BASE_URL             = "http://data.nantes.fr/api"
        static let API_PARK_SERVICE         = "/getDisponibiliteParkingsPublics"
        static let API_PARKING_SCHEDULES    = "/publication/24440040400129_NM_NM_00010/LISTE_HORAIRES_PKGS_PUB_NM_STBL/content"
        static let API_PUBLIC_EQUIPMENTS    = "/publication/24440040400129_NM_NM_00022/LOC_EQUIPUB_MOBILITE_NM_STBL/content"
        static let API_VERSION              = "/1.0"
        static let API_SECRET_KEY           = "/FNJ9U8E8W6EUZTD"
        static let API_JSON_OUTPUT_FORMAT   = "/?output=json"
    }
    
    static let PARKING_SCHEDULES_URL_REQUEST = ApiInfos.API_BASE_URL + ApiInfos.API_PARKING_SCHEDULES + ApiInfos.API_JSON_OUTPUT_FORMAT
    
    static let PUBLIC_EQUIPMENTS_URL_REQUEST = ApiInfos.API_BASE_URL + ApiInfos.API_PUBLIC_EQUIPMENTS + ApiInfos.API_JSON_OUTPUT_FORMAT
    
    static let PARKING_URL_REQUEST =    ApiInfos.API_BASE_URL +
                                        ApiInfos.API_PARK_SERVICE +
                                        ApiInfos.API_VERSION +
                                        ApiInfos.API_SECRET_KEY +
                                        ApiInfos.API_JSON_OUTPUT_FORMAT
    
    
    // MARK: - TableView
    
    struct TableViewInfos {
        static let NIB_NAME         = "ParkingTableViewCell"
        static let CELL_IDENTIFIER  = "ParkingCell"
    }
    
    
    // MARK: - RefreshControl
    
    struct RefreshControlInfos {
        static let ATTRIBUTED_TITLE = "Fetching parkings data"
    }
    
    
    // MARK: - Map
    
    struct MapInfos {
        static let regionRadius     = 1300
        static let nantesLatutide   = 47.2172500
        static let nantesLongitude  = -1.5533600
    }
    
    
    // MARK: - Images
    
    struct Images {
        static let parkingEmpty         = UIImage(named: "Parking-empty-48")
        static let parkingAlmostFull    = UIImage(named: "Parking-almost-full-48")
        static let parkingFull          = UIImage(named: "Parking-full-48")
    }
    
    
    // MARK: - ColorPalette
    
    struct ColorPalette {
        static let pinColorRed      = UIColor(red: 217.0/255.0, green: 95.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        static let pinColorOrange   = UIColor(red: 221.0/255.0, green: 157.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        static let pinColorGreen    = UIColor(red: 104.0/255.0, green: 193.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        static let pinColorWhite    = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
}
