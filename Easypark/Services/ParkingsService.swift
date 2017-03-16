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
    
    func getJsonData(url: String, callback: @escaping (_ data: JSON) -> Void) {
        self.gettingJsonData(url: url) { data in
            callback(data)
        }
    }
    
    private func gettingJsonData(url: String, callback: @escaping (_ data: JSON) -> Void) {
        Alamofire.request(url, method: .get).responseJSON { response in
            guard let responseValue = response.result.value else { return }
            let jsonParsed = JSON(responseValue)
            callback(jsonParsed)
        }
    }
}
