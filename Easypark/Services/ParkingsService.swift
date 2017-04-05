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

class ParkingsService: NSObject {

    public static let sharedInstance = ParkingsService()
    
    public override init() {}
    
    // MARK: - Get parking data in JSON
    
    func getJsonData(url: String, callback: @escaping (_ data: JSON, _ error: NSError?) -> Void) {
        self.gettingJsonData(url: url) { (data, error) in
            callback(data, error)
        }
    }
    
    private func gettingJsonData(url: String, callback: @escaping (_ data: JSON, _ error: NSError?) -> Void) {
        Alamofire.request(url, method: .get).responseJSON { response in
            guard let responseValue = response.result.value else {
                let errorJson = NSError(domain: "ParkingService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No JSON for \(url)"])
                callback(JSON.null, errorJson)
                return
            }
            let jsonParsed = JSON(responseValue)
            callback(jsonParsed, nil)
        }
    }
}
