//
//  JSONManager.swift
//  Easypark
//
//  Created by Sebastien Bastide on 03/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class JSONManager: NSObject {

    public static let sharedInstance = JSONManager()
    
    public override init() {}
    
    public func getJsonDisponibiliteParkings(url: String, callback: @escaping (_ data: JSON) -> Void) {
        Alamofire.request(url).responseJSON { response in
            guard let responseValue = response.result.value else { return }
            let jsonParsed = JSON(responseValue)
            callback(jsonParsed)
        }
    }
}
