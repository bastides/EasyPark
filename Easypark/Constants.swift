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
    
    
    // MARK: - Parking status
    
    struct ParkingStatus {
        static let PARKING_OPEN     = "Ouvert"
        static let PARKING_CLOSED   = "Fermé"
    }
    
    
    // MARK: - TableView
    
    struct TableViewInfos {
        static let NIB_NAME         = "ParkingTableViewCell"
        static let CELL_IDENTIFIER  = "ParkingCell"
        static let TITLE            = "Liste des parkings"
    }

    
    // MARK: - RefreshControl
    
    struct RefreshControlInfos {
        static let ATTRIBUTED_TITLE = "Récupération des données parking"
    }
    
    
    // MARK: - MapView
    
    struct MapViewInfos {
        static let REGION_RADIUS    = 1300
        static let NANTES_LATITUDE  = 47.2172500
        static let NANTES_LONGITUDE = -1.5533600
        static let TITLE            = "Carte des parkings"
        static let PIN_IDENTIFIER   = "parkingPin"
    }
    
    
    // MARK: - ParkingInfosView
    
    struct ParkingInfosView {
        static let NAME_UNAVAILABLE             = "Nom indisponible"
        static let ADDRESS_UNAVAILABLE          = "Adresse indisponible"
        static let POSTAL_CODE_UNAVAILABLE      = "Code postal indisponible"
        static let CITY_UNAVAILABLE             = "Ville indisponible"
        static let PHONE_NUMBER_UNAVAILABLE     = "Numéro de téléphone indisponible"
        static let WEBSITE_UNAVAILABLE          = "Site web indisponible"
        
        static let DEFAULT_PHONE_NUMBER         = "02 40 41 90 00"
        static let DEFAULT_WEBSITE              = "www.parkings-nantes.fr"
    }
    
    
    // MARK: - Images
    
    struct Images {
        static let PARKING              = UIImage(named: "parking-50")
        static let TAB_BAR_LIST_ICON    = UIImage(named: "list-icon")
        static let TAB_BAR_MAP_ICON     = UIImage(named: "map-icon")
    }
    
    
    // MARK: - ColorPalette
    
    struct ColorPalette {
        static let PARKING_OPEN             = UIColor(red: 104.0/255.0, green: 193.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        static let PARKING_CLOSED           = UIColor(red: 217.0/255.0, green: 95.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        
        static let PIN_RED                  = UIColor(red: 217.0/255.0, green: 95.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        static let PIN_GREEN                = UIColor(red: 104.0/255.0, green: 193.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        static let PIN_WHITE                = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        static let TAB_BAR_TINT             = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        static let TAB_BAR_ITEM_SELECTED    = UIColor(red: 41.0/255.0, green: 54.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        static let TAB_BAR_ITEM_DEFAULT     = UIColor(red: 135.0/255.0, green: 138.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        
        static let NAVIGATION_BAR_TINT      = UIColor(red: 41.0/255.0, green: 54.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        static let NAVIGATION_BAR_TITLE     = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        static let PARKING_NAME             = UIColor(red: 41.0/255.0, green: 54.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    }
}
