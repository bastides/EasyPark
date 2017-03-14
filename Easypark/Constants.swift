//
//  Constants.swift
//  Easypark
//
//  Created by Sebastien Bastide on 03/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: - API
    
    struct ApiInfos {
        static let API_BASE_URL             = "http://data.nantes.fr/api"
        static let API_PARK_SERVICE         = "/getDisponibiliteParkingsPublics"
        static let API_VERSION              = "/1.0"
        static let API_SECRET_KEY           = "/39W9VSNCSASEOGV"
        static let API_JSON_OUTPUT_FORMAT   = "/?output=json"
    }
    
    static let parkingsInformationsUrlRequest =     ApiInfos.API_BASE_URL +
                                                    ApiInfos.API_PARK_SERVICE +
                                                    ApiInfos.API_VERSION +
                                                    ApiInfos.API_SECRET_KEY +
                                                    ApiInfos.API_JSON_OUTPUT_FORMAT
    
    
    // MARK: - TableView
    
    struct TableViewInfos {
        static let NIB_NAME = "ParkingTableViewCell"
        static let CELL_IDENTIFIER = "ParkingCell"
    }
    
    
    // MARK: - RefreshControl
    
    struct RefreshControlInfos {
        static let ATTRIBUTED_TITLE = "Fetching parkings data"
    }
}
