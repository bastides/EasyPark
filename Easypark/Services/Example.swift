////
////  UserServiceDataManager.swift
////  Silkke
////
////  Created by Bertrand on 02/09/2015.
////  Copyright (c) 2015 Bertrand Bloc'h. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//import CoreData
//import Alamofire
//import Crashlytics
//
//class UserServiceDataManager: NSObject {
//    
//    static let sharedInstance = UserServiceDataManager()
//    
//    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
//        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
//            completion(data: data)
//            }.resume()
//    }
//    
//    
//    // MARK: - USER
//    
//    internal func modifyUserPassword(user: User!, params: [String : AnyObject], completion: (error: NSError?) -> Void) {
//        modifyUserPassword(user.managedObjectContext, userServiceManager: UserServiceManager.sharedInstance, user: user, params: params, completion: completion)
//    }
//    
//    private func modifyUserPassword(managedObjectContext: NSManagedObjectContext!, userServiceManager: UserServiceManager, user:User?, params: [String : AnyObject], completion: (error: NSError?) -> Void) {
//        
//        let usm             = userServiceManager
//        let contextManager  = ContextManager.sharedInstance
//        
//        let patchErrorMessage = "User modification failed"
//        
//        let parentMOC       = user!.managedObjectContext
//        
//        let uri = ApiURLManager.sharedInstance.returnUpdatePasswordURL()
//        
//        usm.patch(uri, parameters: params, headers: nil, completion: { (modifiedObjectHref, error, data) -> Void in
//            
//            if error == nil {
//                
//                contextManager.password! = params["new_password"] as! String
//                
//                let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                
//                var saveTempMocError :NSError?
//                CoreDataStack.saveContext(tempMoc, error:&saveTempMocError)
//                
//                if saveTempMocError == nil {
//                    var saveParentMocError :NSError?
//                    CoreDataStack.saveContext(parentMOC, error:&saveParentMocError)
//                    completion(error: saveParentMocError)
//                } else {
//                    completion(error: saveTempMocError)
//                }
//                
//            } else {
//                let theError = NSError(domain: "UserServiceManager", code:3, userInfo: [NSLocalizedDescriptionKey:patchErrorMessage])
//                completion(error: theError)
//            }
//        })
//    }
//    
//    internal func persistCurrentUserData(managedObjectContext: NSManagedObjectContext, completion: (userObjectID: NSManagedObjectID?, error: NSError?) -> Void) {
//        self.persistCurrentUserData(managedObjectContext, userServiceManager: UserServiceManager.sharedInstance) { (userObjectID, error) -> Void in
//            completion(userObjectID: userObjectID, error: error)
//        }
//    }
//    
//    private func persistCurrentUserData(managedObjectContext: NSManagedObjectContext, userServiceManager: UserServiceManager, completion: (userObjectID: NSManagedObjectID?, error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        deleteAllPicturesFromDatabase(managedObjectContext)
//        
//        usm.silkkeRootLocation = Constants.Silkke_Web.account
//        let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(managedObjectContext)
//        
//        if let _ = usm.silkkeRootLocation {
//            
//            // Retrieve the user
//            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
//                usm.retrieveUser({ (data, error) -> Void in
//                    
//                    if error == nil {
//                        
//                        guard let userInfos = data.dictionary ?? nil else {
//                            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no userInfos"])
//                            return completion(userObjectID: nil, error: theError)
//                        }
//                        
//                        var userKey: String? = EmptyString
//                        let t = userInfos["id"]?.stringValue
//                        let v = userInfos["email"]?.stringValue
//                        
//                        if t != EmptyString && v != EmptyString {
//                            userKey = t! + "_" + v!
//                        } else {
//                            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no userInfos"])
//                            completion(userObjectID: nil, error: theError)
//                        }
//                        
//                        guard userKey != EmptyString else {
//                            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no userInfos"])
//                            return completion(userObjectID: nil, error: theError)
//                        }
//                        
//                        var theUser                         = User.userForUserKey(userKey!, moc: tempMoc)
//                        
//                        if theUser == nil {
//                            theUser                         = User(managedObjectContext: tempMoc)
//                        }
//                        if theUser != nil {
//                            
//                            if let birthDate                = userInfos["birthDate"]?.stringValue {
//                                theUser?.birthday           = Constants.serverDateFormat.dateFromString(birthDate)
//                            }
//                            
//                            theUser?.defaultAvatar          = userInfos["defaultAvatar"]?.stringValue
//                            theUser?.name                   = userInfos["lastName"]?.stringValue
//                            theUser?.firstName              = userInfos["firstName"]?.stringValue
//                            theUser?.city                   = userInfos["city"]?.stringValue
//                            theUser?.zipCode                = userInfos["zipCode"]?.stringValue
//                            theUser?.email                  = userInfos["email"]?.stringValue
//                            theUser?.street1                = userInfos["address"]?.stringValue
//                            theUser?.street2                = userInfos["addressComplement"]?.stringValue
//                            theUser?.countryId              = userInfos["idCountry"]?.intValue
//                            theUser?.countryTitle           = userInfos["countryName"]?.stringValue
//                            theUser?.idSubject              = userInfos["id"]?.stringValue
//                            theUser?.userToken              = userKey
//                            
//                            self.persistPicturesAndPictureDatasForUser(theUser!, managedObjectContext: tempMoc!, userServiceManager: usm, completion: { (userObjectID, error) -> Void in
//                                if error == nil {
//                                    completion(userObjectID: userObjectID, error: error)
//                                } else {
//                                    completion(userObjectID: userObjectID, error: error)
//                                }
//                            })
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue()) {
//                            var saveError :NSError?
//                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                            
//                            if saveError == nil {
//                                CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                                if saveError == nil {
//                                    completion(userObjectID: theUser!.objectID, error: saveError);
//                                } else {
//                                    completion(userObjectID: nil, error: saveError);
//                                }
//                                
//                            }
//                        }
//                        
//                    } else {
//                        let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no  profile for user"])
//                        completion(userObjectID: nil, error: theError)
//                    }
//                })
//            }
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"user not logged in"])
//            completion(userObjectID:nil, error: theError)
//        }
//    }
//    
//    
//    internal func patchCurrentUserData(user: User, parameters: UserParams, managedObjectContext: NSManagedObjectContext, completion: (error: NSError?) -> Void) {
//        self.patchCurrentUserData(user, parameters: parameters, managedObjectContext: managedObjectContext, userServiceManager: UserServiceManager.sharedInstance) { (error) in
//            completion(error: error)
//        }
//    }
//    
//    private func patchCurrentUserData(user: User, parameters: UserParams, managedObjectContext: NSManagedObjectContext, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        var isValid :Bool = true
//        var validityError :NSError?
//        var errorMessage = "no error message provided by the developer"
//        
//        let pushErrorMessage = "User modification failed"
//        
//        if user.name == nil {
//            isValid = false
//            errorMessage = "The User is in an invalid state because the name is not set"
//        }
//        if user.firstName == nil {
//            isValid = false
//            errorMessage = "The User is in an invalid state because the firstname is not set"
//        }
//        
//        if isValid == false {
//            validityError = NSError(domain: "UserServiceManager", code:3, userInfo: [NSLocalizedDescriptionKey:errorMessage])
//            completion(error: validityError)
//        }  else {
//            
//            let parentMOC = user.managedObjectContext
//            
//            var params: [String : AnyObject] = [
//                "birthDay"      : Constants.serverDateFormat.stringFromDate(parameters.birthday!),
//                ]
//            
//            if let param = parameters.year {
//                params["year"] = param
//            } else {
//                params["year"] = ""
//            }
//            if let param = parameters.month {
//                params["month"] = param
//            } else {
//                params["month"] = ""
//            }
//            if let param = parameters.day {
//                params["day"] = param
//            } else {
//                params["day"] = ""
//            }
//            if let param = parameters.name {
//                params["name"] = param
//            } else {
//                params["name"] = ""
//            }
//            if let param = parameters.firstName {
//                params["firstName"] = param
//            } else {
//                params["firstName"] = ""
//            }
//            if let param = parameters.street1 {
//                params["street1"] = param
//            } else {
//                params["street1"] = ""
//            }
//            if let param = parameters.street2 {
//                params["street2"] = param
//            } else {
//                params["street2"] = ""
//            }
//            if let param = parameters.zipCode {
//                params["zip"] = param
//            } else {
//                params["zip"] = ""
//            }
//            if let param = parameters.city {
//                params["city"] = param
//            } else {
//                params["city"] = ""
//            }
//            
//            if let param = parameters.idCountry {
//                params["country"] = param
//            } else {
//                params["country"] = ""
//            }
//            
//            params["_method"] = "PATCH"//Since Update to OAuth2
//            
//            usm.post(Constants.Silkke_Web.account, parameters: params, headers: nil, loginRequest: false, completion: { (createdObjectHref, error, data) -> Void in
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    var saveTempMocError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error:&saveTempMocError)
//                    
//                    if saveTempMocError == nil {
//                        var saveParentMocError :NSError?
//                        CoreDataStack.saveContext(parentMOC, error:&saveParentMocError)
//                        completion(error: saveParentMocError)
//                    } else {
//                        completion(error: saveTempMocError)
//                    }
//                    
//                } else {
//                    let theError = NSError(domain: "UserServiceManager", code:3, userInfo: [NSLocalizedDescriptionKey:pushErrorMessage])
//                    completion(error: theError)
//                }
//            })
//            
//            //            usm.patch(Constants.Silkke_Web.account, parameters: params, headers: nil, completion: { (modifiedObjectHref, error, data) -> Void in
//            //                if error == nil {
//            //
//            //                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//            //
//            //                    var saveTempMocError :NSError?
//            //                    CoreDataStack.saveContext(tempMoc, error:&saveTempMocError)
//            //
//            //                    if saveTempMocError == nil {
//            //                        var saveParentMocError :NSError?
//            //                        CoreDataStack.saveContext(parentMOC, error:&saveParentMocError)
//            //                        completion(error: saveParentMocError)
//            //                    } else {
//            //                        completion(error: saveTempMocError)
//            //                    }
//            //
//            //                } else {
//            //                    let theError = NSError(domain: "UserServiceManager", code:3, userInfo: [NSLocalizedDescriptionKey:pushErrorMessage])
//            //                    completion(error: theError)
//            //                }
//            //            })
//        }
//    }
//    
//    // MARK: - PICTURE
//    
//    
//    private func persistPicturesAndPictureDatasForUser(user: User, managedObjectContext: NSManagedObjectContext, userServiceManager: UserServiceManager, completion: (userObjectID: NSManagedObjectID?, error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let photosUri = ApiURLManager.sharedInstance.returnPhotoListURL()
//        
//        if photosUri != "" {
//            
//            usm.retrieveResourceForUri(photosUri, urlParametersDictionary: nil, completion: { (pictureDataResponse, error) -> Void in
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                    
//                    // Il faut etre plus fin sinon l'UI clignote!
//                    //userLocalInstance.removeUserBooks(userLocalInstance.userBooks)
//                    
//                    let beforeUpdate = userLocalInstance.userPictures.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(PictureAttributes.pictureUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    if let pictures = pictureDataResponse["photos"].array {
//                        for (myPicture): (JSON) in pictures {
//                            
//                            var idImage = 0
//                            
//                            //                            #if DEBUG
//                            //                                println("=======================")
//                            //                                println("======PICTUREDATA======")
//                            //                                println("\(myPicture)")
//                            //                                println("========================")
//                            //                            #endif
//                            
//                            let currentPicture: AnyObject = myPicture.object
//                            
//                            // On genere un string unique pour indexer les pictures
//                            var pictureUri :String?
//                            if currentPicture.isKindOfClass(NSArray) {
//                                print("isArray")
//                            } else if currentPicture.isKindOfClass(NSDictionary) {
//                                let pictureLibel                    = myPicture["capsule"].stringValue
//                                let pictureUrl                      = myPicture["url"].stringValue
//                                
//                                pictureUri = pictureLibel + "_" + pictureUrl
//                            }
//                            
//                            if let currentPictureUri = pictureUri {
//                                
//                                // the book still exist on server
//                                uriBeforeUpdate.removeObject(currentPictureUri)
//                                
//                                var picture                             = Picture.pictureForUri(pictureUri!, moc: tempMoc)
//                                
//                                if picture == nil {
//                                    picture                             = Picture(managedObjectContext: tempMoc)
//                                }
//                                if picture != nil {
//                                    
//                                    if let imgUrlArray = myPicture["imgs"].array {
//                                        if imgUrlArray.count > 0 {
//                                            
//                                            picture!.pictureUri                 = pictureUri
//                                            
//                                            picture?.title                      = myPicture["capsule"].stringValue
//                                            picture?.idPicture                  = myPicture["idPicture3D"].intValue
//                                            
//                                            var day                             = myPicture["date"]["day"].stringValue
//                                            var month                           = myPicture["date"]["month"].stringValue
//                                            let year                            = myPicture["date"]["year"].stringValue
//                                            
//                                            if day.characters.count < 2 {
//                                                day = "0" + day
//                                            }
//                                            
//                                            if month.characters.count < 2 {
//                                                month = "0" + month
//                                            }
//                                            
//                                            let fullDate                        = year + "-" + month + "-" + day + " 00:00:00"
//                                            
//                                            picture?.date                       = Constants.serverDateFormat.dateFromString(fullDate)
//                                            
//                                            picture?.pictureUrl  = imgUrlArray.first!.stringValue
//                                            
//                                            userLocalInstance.addUserPicturesObject(picture)
//                                            
//                                            picture?.removePictureDatas(picture!.pictureDatas)
//                                            
//                                            if let imageUrlArray = myPicture["imgs"].array {
//                                                
//                                                for (imageUrl): (JSON) in imageUrlArray {
//                                                    
//                                                    let currentImageUrl: AnyObject = imageUrl.object
//                                                    
//                                                    // On genere un string unique pour indexer les pictures
//                                                    var imgUri :String?
//                                                    
//                                                    let imgUrl                      = currentImageUrl as! String
//                                                    let pictureUrl                  = myPicture["url"].stringValue
//                                                    
//                                                    imgUri = imgUrl + "_" + pictureUrl + "_" + "\(idImage)"
//                                                    
//                                                    var pictureData                 = PictureData.pictureDataForPictureDataUri(imgUri!, moc: tempMoc)
//                                                    
//                                                    if pictureData == nil {
//                                                        pictureData                 = PictureData(managedObjectContext: tempMoc)
//                                                    }
//                                                    if pictureData != nil {
//                                                        
//                                                        pictureData?.pictureDataUri = imgUri
//                                                        pictureData?.pictureDataUrl = currentImageUrl as? String
//                                                        pictureData?.isDownloaded   = false
//                                                        pictureData?.pictureNumber  = idImage
//                                                        
//                                                        picture?.addPictureDatasObject(pictureData)
//                                                        
//                                                        idImage += 1
//                                                        
//                                                    }
//                                                    
//                                                    var saveError :NSError?
//                                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                    
//                                                    if saveError == nil {
//                                                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                                                        if saveError == nil {
//                                                            completion(userObjectID: user.objectID, error: saveError);
//                                                        } else {
//                                                            completion(userObjectID: user.objectID, error: saveError);
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let aPicture = Picture.pictureForUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if aPicture != nil {
//                                    print("deleting object: error(Picture not exists on server anymore)")
//                                    tempMoc?.deleteObject(aPicture!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(userObjectID: user.objectID, error: saveError);
//                    } else {
//                        completion(userObjectID: user.objectID, error: saveError);
//                    }
//                    
//                } else {
//                    completion(userObjectID: user.objectID, error: error);
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no photosUri"])
//            completion(userObjectID: user.objectID, error: theError)
//        }
//    }
//    
//    
//    // MARK: - CAPSULE
//    
//    internal func persistCapsuleInformations(managedObjectContext: NSManagedObjectContext, completion: (error: NSError?) -> Void) {
//        self.persistCapsuleInformations(managedObjectContext, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistCapsuleInformations(managedObjectContext: NSManagedObjectContext, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        deleteAllCapsulesFromDatabase(managedObjectContext)
//        
//        let usm = userServiceManager
//        
//        let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(managedObjectContext)
//        
//        let capsuleUri = ApiURLManager.sharedInstance.returnGetCapsulesURL()
//        
//        if capsuleUri != "" {
//            
//            usm.retrieveResourceForUri(capsuleUri, urlParametersDictionary: nil, completion: { (capsuleData, error) -> Void in
//                
//                if error == nil {
//                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
//                        
//                        if let capsulesArray = capsuleData["capsules"].array {
//                            
//                            for (capsuleResData): (JSON) in capsulesArray {
//                                
//                                //                                #if DEBUG
//                                //                                    dispatch_async(dispatch_get_main_queue()) {
//                                //                                        println("=======================")
//                                //                                        println("======CAPSULEDATA======")
//                                //                                        println("\(capsuleResData)")
//                                //                                        println("========================")
//                                //                                    }
//                                //                                #endif
//                                
//                                let currentTimeSlot: AnyObject = capsuleResData.object
//                                
//                                // On genere un string unique pour indexer les capsules
//                                var capsuleUri :String?
//                                
//                                if currentTimeSlot.isKindOfClass(NSArray) {
//                                    
//                                } else if currentTimeSlot.isKindOfClass(NSDictionary) {
//                                    let capsIdCapsule               = String(currentTimeSlot["idCapsule"])
//                                    let capsIdLocation              = String(currentTimeSlot["idLocation"])
//                                    capsuleUri                      = capsIdCapsule + "_" + capsIdLocation
//                                }
//                                
//                                var capsule                         = Capsule.capsuleForUri(capsuleUri!, moc: tempMoc)
//                                
//                                if capsule == nil {
//                                    capsule                         = Capsule(managedObjectContext: tempMoc)
//                                }
//                                if capsule != nil {
//                                    if let beginDate                = capsuleResData["begin"].string {
//                                        capsule?.beginDate          = Constants.serverDateFormat.dateFromString(beginDate)
//                                    }
//                                    if let endDate                  = capsuleResData["end"].string {
//                                        capsule?.endDate            = Constants.serverDateFormat.dateFromString(endDate)
//                                    }
//                                    capsule?.currency               = capsuleResData["currency"].string
//                                    capsule?.idCapsuleLocation      = capsuleResData["idCapsuleLocation"].intValue
//                                    capsule?.city                   = capsuleResData["city"].string
//                                    capsule?.state                  = capsuleResData["state"].numberValue
//                                    capsule?.latitude               = capsuleResData["Y"].numberValue
//                                    capsule?.longitude              = capsuleResData["X"].numberValue
//                                    capsule?.price                  = capsuleResData["creneauPrice"].numberValue
//                                    capsule?.idCapsule              = capsuleResData["idCapsule"].intValue
//                                    capsule?.idCountry              = capsuleResData["idCountry"].intValue
//                                    capsule?.idLocation             = capsuleResData["idLocation"].stringValue
//                                    capsule?.name                   = capsuleResData["libel"].string
//                                    capsule?.street                 = capsuleResData["address"].string
//                                    capsule?.zipCode                = capsuleResData["zipCode"].string
//                                    
//                                    var longString      = ""
//                                    var latString       = ""
//                                    if let longitude    = capsule?.longitude {
//                                        longString      = longitude.stringValue
//                                    }
//                                    if let latitude     = capsule?.latitude {
//                                        latString       = latitude.stringValue
//                                    }
//                                    capsule?.locationStringKey      = longString + "_" + latString
//                                }
//                                
//                                var saveError :NSError?
//                                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                
//                                if saveError == nil {
//                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                    completion(error: saveError);
//                                } else {
//                                    completion(error: saveError);
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//        }
//    }
//    
//    internal func persistOpenDaysForCapsule(capsule: Capsule, startOffset: Int, endOffset: Int, managedObjectContext: NSManagedObjectContext, completion: (error: NSError?) -> Void) {
//        self.persistOpenDaysForCapsule(capsule, startOffset: startOffset, endOffset: endOffset, managedObjectContext: managedObjectContext, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistOpenDaysForCapsule(capsule: Capsule, startOffset: Int, endOffset: Int, managedObjectContext: NSManagedObjectContext, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let capsIdLocation  = String(stringInterpolationSegment: capsule.idCapsuleLocation!)
//        let capsIdCapsule   = String(stringInterpolationSegment: capsule.idCapsule!)
//        
//        let capsuleMOID = capsule.objectID
//        let parentMOC = capsule.managedObjectContext
//        
//        let capsuleUri = ApiURLManager.sharedInstance.returnGetCapsulesURL()
//        
//        if capsuleUri != nil {
//            
//            usm.retrieveResourceForUri(capsuleUri, urlParametersDictionary: nil, completion: { (capsuleData, error) -> Void in
//                
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let capsuleLocalInstance = tempMoc?.objectWithID(capsuleMOID) as! Capsule
//                    
//                    // Il faut etre plus fin sinon l'UI clignote!
//                    //userLocalInstance.removeUserBooks(userLocalInstance.userBooks)
//                    
//                    let beforeUpdate = capsuleLocalInstance.capsuleOpenDays.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(OpenDaysAttributes.openDayUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    if let capsulesArray = capsuleData["capsules"].array {
//                        
//                        for capsuleResData: JSON in capsulesArray {
//                            if capsuleResData["idCapsuleLocation"].stringValue == capsIdLocation {
//                                if capsuleResData["idCapsule"].stringValue == capsIdCapsule {
//                                    
//                                    //                                    dispatch_async(dispatch_get_main_queue()) {
//                                    //                                        print("=======================")
//                                    //                                        print("======CAPSULEDATA======")
//                                    //                                        print("Give the hour range for each type of days (from 0 to 6)")
//                                    //                                        print("\(capsuleResData)")
//                                    //                                        print("========================")
//                                    //                                    }
//                                    
//                                    for index in startOffset...endOffset {
//                                        
//                                        let dayInfoUri = ApiURLManager.sharedInstance.returnObtainSlotsForMonthURL(idCapsuleLocation: capsIdLocation)
//                                        
//                                        if dayInfoUri != nil {
//                                            
//                                            let urlParametersDictionary = [
//                                                "offset": String(index)
//                                            ]
//                                            
//                                            usm.retrieveResourceForUri(dayInfoUri, urlParametersDictionary: urlParametersDictionary, completion: { (openDaysData, error) -> Void in
//                                                if error == nil {
//                                                    
//                                                    if let openDaysDictionary = openDaysData.dictionary {
//                                                        
//                                                        // On genere un string unique pour indexer
//                                                        var currentOpenDayUri :String?
//                                                        
//                                                        let prevMonth               = openDaysDictionary["prev_month"]!.stringValue
//                                                        let nextMonth               = openDaysDictionary["next_month"]!.stringValue
//                                                        let currentMonth            = openDaysDictionary["month"]!.stringValue
//                                                        let year                    = openDaysDictionary["year"]!.stringValue
//                                                        
//                                                        currentOpenDayUri           = prevMonth + "_" + nextMonth + "_" + currentMonth + "_" + year
//                                                        
//                                                        var openDay                     = OpenDays.openDaysForOpenDayUri(currentOpenDayUri!, moc: tempMoc)
//                                                        
//                                                        if openDay == nil {
//                                                            openDay                     = OpenDays(managedObjectContext: tempMoc)
//                                                        }
//                                                        if openDay != nil {
//                                                            openDay?.prevMonth          = openDaysDictionary["prev_month"]!.string
//                                                            openDay?.next_month         = openDaysDictionary["next_month"]!.string
//                                                            openDay?.currentMonth       = openDaysDictionary["month"]!.string
//                                                            openDay?.year               = openDaysDictionary["year"]!.string
//                                                            openDay?.openDayUri         = currentOpenDayUri
//                                                            
//                                                            capsuleLocalInstance.addCapsuleOpenDaysObject(openDay)
//                                                            
//                                                            openDay?.removeDayInfos(openDay!.dayInfos)
//                                                            
//                                                            if let dayInfosArray = openDaysDictionary["calendar"]!.array {
//                                                                
//                                                                for dayInfosData: JSON in dayInfosArray {
//                                                                    
//                                                                    // On genere un string unique pour indexer
//                                                                    var currentDayInfoUri :String?
//                                                                    
//                                                                    let dayNumberTypeString                     = dayInfosData["day"].stringValue
//                                                                    let dateDayNumberString                     = dayInfosData["date"]["day"].stringValue
//                                                                    let dateMonthNumberString                   = dayInfosData["date"]["month"].stringValue
//                                                                    let dateYearNumberString                    = dayInfosData["date"]["year"].stringValue
//                                                                    
//                                                                    currentDayInfoUri = dayNumberTypeString + "_" + dateDayNumberString + "_" + dateMonthNumberString + "_" + dateYearNumberString
//                                                                    
//                                                                    var notNilDateString : String?
//                                                                    notNilDateString = dateDayNumberString + dateMonthNumberString + dateYearNumberString
//                                                                    
//                                                                    if let dstr = notNilDateString {
//                                                                        
//                                                                        if dstr != "000" {
//                                                                            
//                                                                            var dayInfo                     = DayInfos.dayInfoForDayInfoUri(currentDayInfoUri!, moc: tempMoc)
//                                                                            
//                                                                            if dayInfo == nil {
//                                                                                dayInfo                     = DayInfos(managedObjectContext: tempMoc)
//                                                                            }
//                                                                            if dayInfo != nil {
//                                                                                
//                                                                                dayInfo?.dayInfoUri         = currentDayInfoUri
//                                                                                dayInfo?.dayNumberType      = dayInfosData["day"].intValue
//                                                                                dayInfo?.dispoNumber        = dayInfosData["dispo"].intValue
//                                                                                dayInfo?.pasteBool          = dayInfosData["paste"].boolValue
//                                                                                dayInfo?.idLocation         = capsuleResData["idLocation"].stringValue
//                                                                                
//                                                                                var day                     = dayInfosData["date"]["day"].stringValue
//                                                                                var month                   = dayInfosData["date"]["month"].stringValue
//                                                                                let year                    = dayInfosData["date"]["year"].stringValue
//                                                                                
//                                                                                if day.characters.count < 2 {
//                                                                                    day = "0" + day
//                                                                                }
//                                                                                
//                                                                                if month.characters.count < 2 {
//                                                                                    month = "0" + month
//                                                                                }
//                                                                                
//                                                                                dayInfo?.dayString          = day
//                                                                                dayInfo?.monthString        = month
//                                                                                dayInfo?.yearString         = dayInfosData["date"]["year"].stringValue
//                                                                                
//                                                                                let fullDate                = year + "-" + month + "-" + day
//                                                                                
//                                                                                dayInfo?.date               = fullDate
//                                                                                
//                                                                                dayInfo?.dateString         = year + month + day
//                                                                                
//                                                                                openDay?.addDayInfosObject(dayInfo)
//                                                                            }
//                                                                            
//                                                                            var saveError :NSError?
//                                                                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                            
//                                                                            if saveError == nil {
//                                                                                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                                completion(error: saveError);
//                                                                            } else {
//                                                                                completion(error: saveError);
//                                                                            }
//                                                                        }
//                                                                    }
//                                                                }
//                                                            }
//                                                        }
//                                                        
//                                                        var saveError :NSError?
//                                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                        
//                                                        if saveError == nil {
//                                                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                            completion(error: saveError);
//                                                        } else {
//                                                            completion(error: saveError);
//                                                        }
//                                                    }
//                                                }
//                                            })
//                                        }
//                                    }
//                                    var saveError :NSError?
//                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                    
//                                    if saveError == nil {
//                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                        completion(error: saveError);
//                                    } else {
//                                        completion(error: saveError);
//                                    }
//                                    
//                                }
//                            }
//                        }
//                    }
//                    
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let anOpenDay = OpenDays.openDaysForOpenDayUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if anOpenDay != nil {
//                                    print("deleting object: error(OpenDay not exists on server anymore)")
//                                    tempMoc?.deleteObject(anOpenDay!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                    
//                } else {
//                    completion(error: error);
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no BookUri"])
//            completion(error: theError)
//        }
//        
//        
//    }
//    
//    //MARK: - TOPIC
//    
//    internal func persistTopicFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistTopicFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistTopicFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let urlParametersDictionary = [EmptyString : EmptyString]
//        
//        let topicUri = ApiURLManager.sharedInstance.returnGetTopicList()
//        
//        guard topicUri != "" else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no BookUri"])
//            return completion(error: theError)
//        }
//        
//        usm.retrieveResourceForUri(topicUri, urlParametersDictionary: urlParametersDictionary, completion: { (topicData, error) -> Void in
//            
//            guard error == nil else {
//                return completion(error: error)
//            }
//            
//            let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//            
//            let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//            
//            let beforeUpdate = userLocalInstance.userTopics.allObjects as NSArray
//            
//            let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(TopicAttributes.idTopic.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//            
//            if topicData["error"].boolValue == false {
//                
//                if let topicArray = topicData["topics"].array {
//                    
//                    //                    print("####################")
//                    //                    print(topicArray)
//                    //                    print("####################")
//                    
//                    for (currentTopic): (JSON) in topicArray {
//                        
//                        var topicUri            : String?
//                        
//                        let topicNameString     = currentTopic["libel"].stringValue
//                        let idTopicString       = currentTopic["idTopic"].stringValue
//                        
//                        topicUri                = topicNameString + "_" + idTopicString
//                        
//                        if let currentTopicUri  = topicUri {
//                            uriBeforeUpdate.removeObject(currentTopicUri)
//                            
//                            var topic           = Topic.topicForTopicUri(currentTopicUri, moc: tempMoc!)
//                            
//                            if topic == nil {
//                                topic           = Topic(managedObjectContext: tempMoc)
//                            }
//                            
//                            if topic != nil {
//                                
//                                topic?.topicUri            = currentTopicUri
//                                topic?.title               = currentTopic["topic_lang"]["libel"].stringValue
//                                topic?.idTopicSubscription = currentTopic["idTopicSubscription"].stringValue
//                                topic?.idTopic             = currentTopic["idTopic"].stringValue
//                                
//                                userLocalInstance.addUserTopicsObject(topic)
//                                
//                                topic?.removeTopicSubscriptions(topic!.topicSubscriptions)
//                                
//                                if let topicSubscriptionsArray = currentTopic["topic_subscriptions"].array {
//                                    
//                                    for (currentTopicSubscription): (JSON) in topicSubscriptionsArray {
//                                        
//                                        var topicSubUri         : String?
//                                        
//                                        let idTopicString       = currentTopicSubscription["idTopic"].stringValue
//                                        let idTopicSubscriptionType = currentTopicSubscription["idTopicSubscriptionType"].stringValue
//                                        
//                                        topicSubUri                = idTopicString + "_" + idTopicSubscriptionType
//                                        
//                                        if let currentTopicSubUri  = topicSubUri {
//                                            
//                                            var topicSub           = TopicSubscription.topicSubscriptionForTopicUri(currentTopicSubUri, moc: tempMoc!)
//                                            
//                                            if topicSub == nil {
//                                                topicSub           = TopicSubscription(managedObjectContext: tempMoc)
//                                            }
//                                            
//                                            if topicSub != nil {
//                                                topicSub?.topicSubscriptionUri = currentTopicSubUri
//                                                topicSub?.idTopicSubscription = currentTopicSubscription["idTopicSubscription"].stringValue
//                                                topicSub?.idTopicSubscriptionType = currentTopicSubscription["idTopicSubscriptionType"].stringValue
//                                                topicSub?.idTopic = currentTopicSubscription["idTopic"].stringValue
//                                                
//                                                topic?.addTopicSubscriptionsObject(topicSub)
//                                                
//                                                var saveError :NSError?
//                                                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                
//                                                if saveError == nil {
//                                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                    completion(error: saveError);
//                                                } else {
//                                                    completion(error: saveError);
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            
//                            var saveError :NSError?
//                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                            
//                            if saveError == nil {
//                                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                completion(error: saveError);
//                            } else {
//                                completion(error: saveError);
//                            }
//                        }
//                    }
//                }
//            }
//            
//            if uriBeforeUpdate.count > 0 {
//                for toBeLocallyDeletedUri in uriBeforeUpdate {
//                    if toBeLocallyDeletedUri is NSNull == false {
//                        let aTopic = Topic.topicForTopicUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                        if aTopic != nil {
//                            print("deleting object: error(Topic not exists on server anymore)")
//                            #if CRASHLYTICS
//                                CLSLogv("deleting object: error(Topic not exists on server anymore)", getVaList([]))
//                            #endif
//                            tempMoc?.deleteObject(aTopic!)
//                        }
//                    }
//                }
//            }
//            
//            var saveError :NSError?
//            CoreDataStack.saveContext(tempMoc, error: &saveError)
//            
//            if saveError == nil {
//                CoreDataStack.saveContext(parentMOC, error: &saveError)
//                completion(error: saveError);
//            } else {
//                completion(error: saveError);
//            }
//        })
//    }
//    
//    internal func updateTopic(user: User, topic: Topic, idTopicSubscription: String, managedObjectContext: NSManagedObjectContext, completion: (error: NSError?) -> Void) {
//        updateTopic(user, topic: topic, idTopicSubscription: idTopicSubscription, managedObjectContext: managedObjectContext, userServiceDataManager: UserServiceDataManager.sharedInstance) { (error) -> Void in
//            completion(error: error)
//        }
//    }
//    
//    private func updateTopic(user: User?, topic: Topic?, idTopicSubscription: String, managedObjectContext: NSManagedObjectContext, userServiceDataManager: UserServiceDataManager, completion: (error: NSError?) -> Void) {
//        
//        if let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(managedObjectContext) {
//            
//            var theTopic = topic
//            
//            if theTopic == nil {
//                theTopic = Topic(managedObjectContext: tempMoc)
//            } else {
//                theTopic = tempMoc.objectWithID(topic!.objectID) as? Topic
//            }
//            
//            theTopic = topic
//            theTopic?.idTopicSubscription  = idTopicSubscription
//            
//            if theTopic?.topicSubscriptions.allObjects.count > 0 {
//                for currentSubscription in theTopic?.topicSubscriptions as! Set<TopicSubscription> {
//                    if currentSubscription.idTopicSubscription == idTopicSubscription {
//                        theTopic?.removeTopicSubscriptionsObject(currentSubscription)
//                    }
//                }
//            }
//            
//            var saveError :NSError?
//            CoreDataStack.saveContext(tempMoc, error: &saveError)
//            
//            if saveError == nil {
//                CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                completion(error: saveError);
//            } else {
//                let theError = NSError(domain: "SilkkeDataManager", code:1, userInfo: [NSLocalizedDescriptionKey:"Topic local data creation failed"])
//                completion(error: theError)
//            }
//            completion(error: nil)
//        } else {
//            let theError = NSError(domain: "SilkkeDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"No managed object context"])
//            completion(error: theError)
//        }
//        
//    }
//    
//    //MARK: - MOVIES
//    
//    internal func persistMoviesFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistMoviesFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistMoviesFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let categoryUri = ApiURLManager.sharedInstance.returnGetListofMovies()
//        
//        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
//            usm.retrieveResourceForUri(categoryUri, urlParametersDictionary: nil, completion: { (movieData, error) -> Void in
//                
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                    
//                    let beforeUpdate = userLocalInstance.userMovies.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(MovieAttributes.movieUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    let bfrUpdate = userLocalInstance.avatarisedMovies.allObjects as NSArray
//                    
//                    let uriBfrUpdate = (bfrUpdate.valueForKeyPath(AvatarisedMovieAttributes.avatarisedMovieUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    guard let moviesArray = movieData["movies"].array else {
//                        let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"No movies"])
//                        completion(error: theError)
//                        return
//                    }
//                    
//                    for (currentMovie): (JSON) in moviesArray {
//                        
//                        var movieUri :String?
//                        
//                        let idCat = currentMovie["idMovieType"].stringValue
//                        let libel = currentMovie["libel"].stringValue
//                        let type  = currentMovie["idMovie"].stringValue
//                        
//                        movieUri = idCat + "_" + libel + "_" + type
//                        
//                        guard let currentMovieUri = movieUri else {
//                            return
//                        }
//                        
//                        uriBeforeUpdate.removeObject(currentMovieUri)
//                        
//                        var movie             = Movie.movieForMovieUri(currentMovieUri, moc: tempMoc)
//                        
//                        if movie == nil {
//                            movie             = Movie(managedObjectContext: tempMoc)
//                        }
//                        
//                        if movie != nil {
//                            
//                            movie?.movieUri   = movieUri
//                            
//                            movie?.libel      = currentMovie["libel"].stringValue
//                            movie?.idMovie    = currentMovie["idMovie"].stringValue
//                            movie?.bigPicture = currentMovie["image"].stringValue
//                            movie?.movieData  = NSData(contentsOfURL: NSURL(string: currentMovie["sample_video"].stringValue)!)
//                            movie?.sampleUrl  = currentMovie["sample_video"].stringValue
//                            movie?.price      = currentMovie["price"].stringValue
//                            movie?.currency   = currentMovie["currency"].stringValue
//                            movie?.type       = currentMovie["idMovieType"].stringValue /// 1 : snap, 2 : sketch, 3 : story ///
//                            
//                            var avatarisedMovieUrlArray : Array<JSON>?
//                            avatarisedMovieUrlArray = currentMovie["avatars"].array
//                            
//                            guard avatarisedMovieUrlArray != nil else {
//                                return print("No Array")
//                            }
//                            
//                            for (currentAvatarisedMovie): (JSON) in avatarisedMovieUrlArray! {
//                                
//                                var avatarisedMovieURIUri :String?
//                                
//                                let movieId                     = movieUri
//                                let idPicture3D                 = currentAvatarisedMovie["idPicture3D"].stringValue
//                                
//                                avatarisedMovieURIUri = movieId! + "_" + idPicture3D + "_"
//                                
//                                uriBfrUpdate.removeObject(avatarisedMovieURIUri!)
//                                
//                                var avatarisedMovie                 = AvatarisedMovie.avatarisedMovieForAvatarisedMovieUri(avatarisedMovieURIUri!, moc: tempMoc)
//                                
//                                if avatarisedMovie == nil {
//                                    avatarisedMovie                 = AvatarisedMovie(managedObjectContext: tempMoc)
//                                }
//                                if avatarisedMovie != nil {
//                                    
//                                    movie?.removeAvatarisedMoviesObject(avatarisedMovie)
//                                    
//                                    avatarisedMovie?.avatarisedMovieUri = avatarisedMovieURIUri
//                                    avatarisedMovie?.url                = currentAvatarisedMovie["url"].stringValue
//                                    avatarisedMovie?.idPicture          = currentAvatarisedMovie["idPicture3D"].stringValue
//                                    avatarisedMovie?.type               = currentMovie["idMovieType"].stringValue /// 1 : snap, 2 : sketch, 3 : story ///
//                                    
//                                    if avatarisedMovie?.movieData == nil {
//                                        avatarisedMovie?.dataIsDownloaded   = false
//                                    } else {
//                                        avatarisedMovie?.dataIsDownloaded   = true
//                                    }
//                                    
//                                    userLocalInstance.addAvatarisedMoviesObject(avatarisedMovie)
//                                    
//                                    movie?.addAvatarisedMoviesObject(avatarisedMovie)
//                                    
//                                }
//                            }
//                            
//                            userLocalInstance.addUserMoviesObject(movie)
//                            
//                            var saveError :NSError?
//                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                            
//                            if saveError == nil {
//                                CoreDataStack.saveContext(parentMOC, error: &saveError)
//                                completion(error: saveError);
//                            } else {
//                                completion(error: saveError);
//                            }
//                        }
//                    }
//                    
//                    if uriBfrUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBfrUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let anAvatarisedMovie = AvatarisedMovie.avatarisedMovieForAvatarisedMovieUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if anAvatarisedMovie != nil {
//                                    print("deleting object: error(AvatarisedMovie not exists on server anymore)")
//                                    #if CRASHLYTICS
//                                        CLSLogv("deleting object: error(AvatarisedMovie not exists on server anymore)", getVaList([]))
//                                    #endif
//                                    tempMoc?.deleteObject(anAvatarisedMovie!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let aCategory = Movie.movieForMovieUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if aCategory != nil {
//                                    print("deleting object: error(Movie not exists on server anymore)")
//                                    #if CRASHLYTICS
//                                        CLSLogv("deleting object: error(Movie not exists on server anymore)", getVaList([]))
//                                    #endif
//                                    tempMoc?.deleteObject(aCategory!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                }
//            })
//            
//        }
//        
//        
//    }
//    
//    
//    //MARK: - FUNNY APPS
//    
//    internal func persistFunnyAppsMenuFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistFunnyAppsMenuFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistFunnyAppsMenuFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let categoryUri = ApiURLManager.sharedInstance.returnGetListCategory()
//        
//        usm.retrieveResourceForUri(categoryUri, urlParametersDictionary: nil, completion: { (categoryData, error) -> Void in
//            
//            if error == nil {
//                
//                let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                
//                let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                
//                let beforeUpdate = userLocalInstance.categories.allObjects as NSArray
//                
//                let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(CategoryAttributes.categoryUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                
//                
//                guard let categoriesArray = categoryData["categories"].array else {
//                    let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"No categoriesArray"])
//                    completion(error: theError)
//                    return
//                }
//                
//                for (currentCategory): (JSON) in categoriesArray {
//                    
//                    var newsUri :String?
//                    
//                    let idCat                     = currentCategory["idCategory"].stringValue
//                    let libel                     = currentCategory["libel"].stringValue
//                    
//                    newsUri = idCat + "_" + libel
//                    
//                    guard let currentNewsUri = newsUri else {
//                        return
//                    }
//                    
//                    uriBeforeUpdate.removeObject(currentNewsUri)
//                    
//                    var category                        = Category.categoryForCategoryUri(currentNewsUri, moc: tempMoc)
//                    
//                    if category == nil {
//                        category                        = Category(managedObjectContext: tempMoc)
//                    }
//                    
//                    if category != nil {
//                        
//                        category?.categoryUri               = newsUri
//                        category?.libel                     = currentCategory["libel"].stringValue
//                        category?.idUniverse                = currentCategory["idUniverse"].stringValue
//                        category?.idCategory                = currentCategory["idCategory"].stringValue
//                        
//                        userLocalInstance.addCategoriesObject(category)
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                }
//                // remaining News not exists on server anymore : we should delete them
//                if uriBeforeUpdate.count > 0 {
//                    for toBeLocallyDeletedUri in uriBeforeUpdate {
//                        if toBeLocallyDeletedUri is NSNull == false {
//                            let aCategory = Category.categoryForCategoryUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                            if aCategory != nil {
//                                print("deleting object: error(Category not exists on server anymore)")
//                                #if CRASHLYTICS
//                                    CLSLogv("deleting object: error(Category not exists on server anymore)", getVaList([]))
//                                #endif
//                                tempMoc?.deleteObject(aCategory!)
//                            }
//                        }
//                    }
//                }
//                
//                var saveError :NSError?
//                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                
//                if saveError == nil {
//                    CoreDataStack.saveContext(parentMOC, error: &saveError)
//                    completion(error: saveError);
//                } else {
//                    completion(error: saveError);
//                }
//            }
//        })
//    }
//    
//    internal func persistFunnyAppsFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistFunnyAppsFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistFunnyAppsFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let funnyAppUri = ApiURLManager.sharedInstance.returnGetListFunnyAppsURL()
//        
//        if funnyAppUri != "" {
//            
//            usm.retrieveResourceForUri(funnyAppUri, urlParametersDictionary: nil, completion: { (funnyAppsData, error) -> Void in
//                
//                //                print("####################")
//                //                print(funnyAppsData)
//                //                print("####################")
//                
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                    
//                    // Il faut etre plus fin sinon l'UI clignote!
//                    //userLocalInstance.removeUserBooks(userLocalInstance.userBooks)
//                    
//                    let beforeUpdate = userLocalInstance.userFunnyApps.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(FunnyAppAttributes.funnyAppUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    if funnyAppsData["error"].boolValue == false {
//                        
//                        if let funnyAppsDictionary = funnyAppsData.dictionary {
//                            
//                            if let funnyAppsArray = funnyAppsDictionary["apps"]!.array {
//                                
//                                for (currentFunnyApp): (JSON) in funnyAppsArray {
//                                    
//                                    // On genere un string unique pour indexer
//                                    var funnyAppsUri :String?
//                                    
//                                    let tokenString                     = currentFunnyApp["idApplication"].stringValue
//                                    let idQueueString                   = currentFunnyApp["libel"].stringValue
//                                    
//                                    funnyAppsUri = tokenString + "_" + idQueueString
//                                    
//                                    if let currentFunnyAppsUri = funnyAppsUri {
//                                        
//                                        uriBeforeUpdate.removeObject(currentFunnyAppsUri)
//                                        
//                                        var funnyApp                        = FunnyApp.funnyAppForfunnyAppUri(currentFunnyAppsUri, moc: tempMoc)
//                                        
//                                        if funnyApp == nil {
//                                            funnyApp                        = FunnyApp(managedObjectContext: tempMoc)
//                                        }
//                                        
//                                        if funnyApp != nil {
//                                            
//                                            funnyApp?.funnyAppUri           = currentFunnyAppsUri
//                                            funnyApp?.idApplication         = currentFunnyApp["idApplication"].stringValue
//                                            funnyApp?.libel                 = currentFunnyApp["libel"].stringValue
//                                            funnyApp?.imageUrl              = currentFunnyApp["image"].stringValue
//                                            funnyApp?.appDescription        = currentFunnyApp["description"].stringValue
//                                            
//                                            if let idApp = funnyApp?.idApplication {
//                                                let funnyAppInfoUri = ApiURLManager.sharedInstance.returnGetFunnyAppInformationsURL(idApp)
//                                                usm.retrieveResourceForUri(funnyAppInfoUri, urlParametersDictionary: nil, completion: { (data, error) in
//                                                    
//                                                    //                                                    print("####################")
//                                                    //                                                    print(data)
//                                                    //                                                    print("####################")
//                                                    
//                                                    if data["error"].boolValue == false {
//                                                        
//                                                        funnyApp?.version   = data["version"].stringValue
//                                                        funnyApp?.category  = data["idCategory"].stringValue
//                                                        
//                                                        let idCat           = data["idCategory"].stringValue
//                                                        
//                                                        let universeURI     = ApiURLManager.sharedInstance.returnGetUniverseForCategoryID(idCat)
//                                                        
//                                                        /// Waiting for API update
//                                                        usm.retrieveResourceForUri(universeURI, urlParametersDictionary: nil, completion: { (data, error) in
//                                                            
//                                                            if data["error"].boolValue == false {
//                                                                
//                                                                if let platformDic = data["universe"].dictionary {
//                                                                    
//                                                                    funnyApp?.idUniverse = platformDic["idUniverse"]!.stringValue
//                                                                    funnyApp?.universe   = platformDic["libel"]!.stringValue
//                                                                    
//                                                                    var saveError :NSError?
//                                                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                    
//                                                                    if saveError == nil {
//                                                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                        completion(error: saveError);
//                                                                    } else {
//                                                                        completion(error: saveError);
//                                                                    }
//                                                                }
//                                                            }
//                                                        })
//                                                        
//                                                        if let platformArray = data["platforms"].array {
//                                                            for platform in platformArray {
//                                                                
//                                                                let platformId  = platform["idPlatform"].stringValue
//                                                                
//                                                                switch platformId {
//                                                                case Constants.Platforms.iOS:
//                                                                    funnyApp?.ituneStoreURL = platform["url"].stringValue
//                                                                    funnyApp?.plateformID = platformId
//                                                                case Constants.Platforms.Android:
//                                                                    break
//                                                                case Constants.Platforms.StandAlone:
//                                                                    break
//                                                                case Constants.Platforms.WebGL:
//                                                                    break
//                                                                case Constants.Platforms.WindowsPhone:
//                                                                    break
//                                                                default:
//                                                                    break
//                                                                }
//                                                                
//                                                                var saveError :NSError?
//                                                                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                
//                                                                if saveError == nil {
//                                                                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                                                    completion(error: saveError);
//                                                                } else {
//                                                                    completion(error: saveError);
//                                                                }
//                                                            }
//                                                        }
//                                                    } else {
//                                                        funnyApp?.appUrl = ""
//                                                    }
//                                                })
//                                            }
//                                            userLocalInstance.addUserFunnyAppsObject(funnyApp)
//                                        }
//                                        
//                                        var saveError :NSError?
//                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                        
//                                        if saveError == nil {
//                                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                            completion(error: saveError);
//                                        } else {
//                                            completion(error: saveError);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    // remaining Book not exists on server anymore : we should delete them
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let aFunnyApp = FunnyApp.funnyAppForfunnyAppUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if aFunnyApp != nil {
//                                    print("deleting object: error(FunnyApp not exists on server anymore)")
//                                    #if CRASHLYTICS
//                                        CLSLogv("deleting object: error(FunnyApp not exists on server anymore)", getVaList([]))
//                                    #endif
//                                    tempMoc?.deleteObject(aFunnyApp!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                    
//                } else {
//                    completion(error: error);
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no FunnyAppUri"])
//            completion(error: theError)
//        }
//        
//    }
//    
//    //MARK: - COUNTRY
//    
//    internal func persistCountryFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistCountryFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistCountryFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let countryUri = ApiURLManager.sharedInstance.returnGetListCountriesURL()
//        
//        if countryUri != "" {
//            
//            usm.retrieveResourceForUri(countryUri, urlParametersDictionary: nil, completion: { (countryData, error) -> Void in
//                
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                    
//                    // Il faut etre plus fin sinon l'UI clignote!
//                    //userLocalInstance.removeUserBooks(userLocalInstance.userBooks)
//                    
//                    let beforeUpdate = userLocalInstance.userCountry.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(CountryAttributes.countryUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    if countryData["error"].boolValue == false {
//                        
//                        if let countryDictionary = countryData.dictionary {
//                            
//                            //                            println("####################")
//                            //                            println(countryDictionary)
//                            //                            println("####################")
//                            
//                            if let countriesArray = countryDictionary["countries"]!.array {
//                                
//                                for (currentCountry): (JSON) in countriesArray {
//                                    
//                                    // On genere un string unique pour indexer
//                                    var countryUri :String?
//                                    
//                                    let tokenString                     = currentCountry["id"].stringValue
//                                    let idQueueString                   = currentCountry["name"].stringValue
//                                    
//                                    countryUri = tokenString + "_" + idQueueString
//                                    
//                                    if let currentCountryUri = countryUri {
//                                        
//                                        // the country still exist on server
//                                        uriBeforeUpdate.removeObject(currentCountryUri)
//                                        
//                                        var country                        = Country.countryForCountryUri(currentCountryUri, moc: tempMoc)
//                                        
//                                        if country == nil {
//                                            country                        = Country(managedObjectContext: tempMoc)
//                                        }
//                                        
//                                        if country != nil {
//                                            
//                                            country?.countryUri            = currentCountryUri
//                                            country?.countryID             = currentCountry["id"].intValue
//                                            country?.name                  = currentCountry["name"].stringValue
//                                            
//                                            userLocalInstance.addUserCountryObject(country)
//                                        }
//                                        
//                                        var saveError :NSError?
//                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                        
//                                        if saveError == nil {
//                                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                            completion(error: saveError);
//                                        } else {
//                                            completion(error: saveError);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    // remaining Country not exists on server anymore : we should delete them
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let aCountry = Country.countryForCountryUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if aCountry != nil {
//                                    print("deleting object: error(Country not exists on server anymore)")
//                                    #if CRASHLYTICS
//                                        CLSLogv("deleting object: error(Country not exists on server anymore)", getVaList([]))
//                                    #endif
//                                    tempMoc?.deleteObject(aCountry!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                    
//                } else {
//                    completion(error: error);
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no CountryUri"])
//            completion(error: theError)
//        }
//        
//    }
//    
//    //MARK: - NEWS
//    
//    internal func persistNewsFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistNewsFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistNewsFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let newsUri = Constants.SILKKE_WORDPRESS
//        
//        usm.retrieveResourceForUri(newsUri, urlParametersDictionary: nil, completion: { (newsData, error) -> Void in
//            if error == nil {
//                
//                let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                
//                let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                
//                let beforeUpdate = userLocalInstance.news.allObjects as NSArray
//                
//                let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(NewsAttributes.newsUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                
//                guard let newsArray = newsData.array else {
//                    let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"No newsArray"])
//                    completion(error: theError)
//                    return
//                }
//                
//                for (currentNews): (JSON) in newsArray {
//                    
//                    if currentNews["title"]["rendered"].stringValue != "homepage" /** temporary solution for homeBg//TODELETE **/ {
//                        
//                        var newsUri :String?
//                        
//                        let rendered                     = currentNews["title"]["rendered"].stringValue
//                        let date_gmt                     = currentNews["date_gmt"].stringValue
//                        
//                        newsUri = rendered + "_" + date_gmt
//                        
//                        guard let currentNewsUri = newsUri else {
//                            return
//                        }
//                        
//                        uriBeforeUpdate.removeObject(currentNewsUri)
//                        
//                        var news                        = News.newsForNewsUri(currentNewsUri, moc: tempMoc)
//                        
//                        if news == nil {
//                            news                        = News(managedObjectContext: tempMoc)
//                        }
//                        
//                        if news != nil {
//                            
//                            news?.newsUri               = newsUri
//                            news?.title                 = currentNews["title"]["rendered"].stringValue
//                            news?.text                  = currentNews["content"]["rendered"].stringValue
//                            news?.imgUrl                = currentNews["featured_image_thumbnail_url"].stringValue
//                            let yearMonthDay            = currentNews["date_gmt"].stringValue[0...9]
//                            let hour                    = currentNews["date_gmt"].stringValue[11..<currentNews["date_gmt"].stringValue.characters.count]
//                            let date                    = yearMonthDay + " " + hour
//                            news?.date                  = Constants.serverDateFormat.dateFromString(date)
//                            
//                            userLocalInstance.addNewsObject(news)
//                        }
//                        
//                        var saveError :NSError?
//                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                        
//                        if saveError == nil {
//                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                            completion(error: saveError);
//                        } else {
//                            completion(error: saveError);
//                        }
//                        
//                    }
//                }
//                // remaining News not exists on server anymore : we should delete them
//                if uriBeforeUpdate.count > 0 {
//                    for toBeLocallyDeletedUri in uriBeforeUpdate {
//                        if toBeLocallyDeletedUri is NSNull == false {
//                            let aBook = News.newsForNewsUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                            if aBook != nil {
//                                print("deleting object: error(Book not exists on server anymore)")
//                                #if CRASHLYTICS
//                                    CLSLogv("deleting object: error(Book not exists on server anymore)", getVaList([]))
//                                #endif
//                                tempMoc?.deleteObject(aBook!)
//                            }
//                        }
//                    }
//                }
//                
//                var saveError :NSError?
//                CoreDataStack.saveContext(tempMoc, error: &saveError)
//                
//                if saveError == nil {
//                    CoreDataStack.saveContext(parentMOC, error: &saveError)
//                    completion(error: saveError);
//                } else {
//                    completion(error: saveError);
//                }
//            }
//        })
//    }
//    
//    //MARK: - BOOK
//    
//    internal func persistBookFromCurrentUser(user: User, completion: (error: NSError?) -> Void) {
//        self.persistBookFromCurrentUser(user, userServiceManager: UserServiceManager.sharedInstance) { (error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(error: error)
//            }
//        }
//    }
//    
//    private func persistBookFromCurrentUser(user: User, userServiceManager: UserServiceManager, completion: (error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let userMOID = user.objectID
//        let parentMOC = user.managedObjectContext
//        
//        let bookUri = ApiURLManager.sharedInstance.returnGetBookedEventsURLWithoutStatus()
//        
//        if bookUri != "" {
//            
//            usm.retrieveResourceForUri(bookUri, urlParametersDictionary: nil, completion: { (bookData, error) -> Void in
//                
//                if error == nil {
//                    
//                    let tempMoc = CoreDataStack.temporaryManagedObjectContextWithParent(parentMOC!)
//                    
//                    let userLocalInstance = tempMoc?.objectWithID(userMOID) as! User
//                    
//                    // Il faut etre plus fin sinon l'UI clignote!
//                    //userLocalInstance.removeUserBooks(userLocalInstance.userBooks)
//                    
//                    let beforeUpdate = userLocalInstance.userBooks.allObjects as NSArray
//                    
//                    let uriBeforeUpdate = (beforeUpdate.valueForKeyPath(BookAttributes.bookUri.rawValue) as! NSArray).mutableCopy() as! NSMutableArray
//                    
//                    if bookData["error"].boolValue == false {
//                        
//                        if let bookDictionary = bookData.dictionary {
//                            
//                            //                            println("####################")
//                            //                            println(bookDictionary)
//                            //                            println("####################")
//                            
//                            if let queuesArray = bookDictionary["queues"]!.array {
//                                
//                                for (currentBook): (JSON) in queuesArray {
//                                    
//                                    // On genere un string unique pour indexer
//                                    var bookUri :String?
//                                    
//                                    let tokenString                     = currentBook["token"].stringValue
//                                    let idQueueString                   = currentBook["idQueue"].stringValue
//                                    
//                                    bookUri = tokenString + "_" + idQueueString
//                                    
//                                    if let currentBookUri = bookUri {
//                                        
//                                        // the book still exist on server
//                                        uriBeforeUpdate.removeObject(currentBookUri)
//                                        
//                                        var book                        = Book.bookForBookUri(currentBookUri, moc: tempMoc)
//                                        
//                                        if book == nil {
//                                            book                        = Book(managedObjectContext: tempMoc)
//                                        }
//                                        if book != nil {
//                                            
//                                            book?.bookUri               = currentBookUri
//                                            book?.endDate               = Constants.serverDateFormat.dateFromString(currentBook["date"].stringValue)
//                                            book?.label                 = currentBook["capsule"]["libel"].stringValue
//                                            book?.address               = currentBook["capsule"]["address"].stringValue
//                                            book?.city                  = currentBook["capsule"]["city"].stringValue
//                                            book?.zipCode               = currentBook["capsule"]["zipCode"].stringValue
//                                            book?.idSubject             = currentBook["idSubject"].intValue
//                                            book?.datePicture           = Constants.serverDateFormat.dateFromString(currentBook["datePicture"].stringValue)
//                                            book?.qrIndex               = currentBook["qrIndex"].stringValue
//                                            book?.path                  = currentBook["path"].stringValue
//                                            book?.idTransaction         = currentBook["idTransaction"].stringValue
//                                            book?.idCoupon              = currentBook["idCoupon"].intValue
//                                            book?.token                 = currentBook["token"].stringValue
//                                            book?.timeZone              = currentBook["timeZone"].stringValue
//                                            book?.idCapsule             = currentBook["idCapsule"].intValue
//                                            book?.bucket                = currentBook["bucket"].stringValue
//                                            book?.idQueue               = currentBook["idQueue"].intValue
//                                            book?.status                = currentBook["status"].intValue
//                                            book?.idPicture             = currentBook["idPicture3D"].intValue
//                                            book?.pictureUrl            = currentBook["picture3D"][0].stringValue
//                                            book?.dateReserved          = Constants.serverDateFormat.dateFromString(currentBook["dateReserved"].stringValue)
//                                            
//                                            book?.capsule               = Capsule.capsuleForID(book!.idCapsule!, moc: tempMoc)
//                                            
//                                            userLocalInstance.addUserBooksObject(book)
//                                        }
//                                        
//                                        var saveError :NSError?
//                                        CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                        
//                                        if saveError == nil {
//                                            CoreDataStack.saveContext(tempMoc, error: &saveError)
//                                            completion(error: saveError);
//                                        } else {
//                                            completion(error: saveError);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    // remaining Book not exists on server anymore : we should delete them
//                    if uriBeforeUpdate.count > 0 {
//                        for toBeLocallyDeletedUri in uriBeforeUpdate {
//                            if toBeLocallyDeletedUri is NSNull == false {
//                                let aBook = Book.bookForBookUri(toBeLocallyDeletedUri as! String, moc: tempMoc)
//                                if aBook != nil {
//                                    print("deleting object: error(Book not exists on server anymore)")
//                                    #if CRASHLYTICS
//                                        CLSLogv("deleting object: error(Book not exists on server anymore)", getVaList([]))
//                                    #endif
//                                    tempMoc?.deleteObject(aBook!)
//                                }
//                            }
//                        }
//                    }
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(tempMoc, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(parentMOC, error: &saveError)
//                        completion(error: saveError);
//                    } else {
//                        completion(error: saveError);
//                    }
//                    
//                } else {
//                    completion(error: error);
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no BookUri"])
//            completion(error: theError)
//        }
//    }
//    
//    //MARK: - SLOTOBJECT
//    
//    internal func returnSlotArrayForDayInfosAndCapsule(selectedCapsule: Capsule!, selectedDayInfos: DayInfos!, completion: (result: Any, error: NSError!, SlotsAvailable: Bool)->Void) -> Void {
//        
//        let usm = UserServiceManager.sharedInstance
//        
//        var objectArray         = [Objects]()
//        var slotArray           = [SlotObject]()
//        var headerHourTextArray = [Int]()
//        
//        slotArray.removeAll(keepCapacity: false)
//        headerHourTextArray.removeAll(keepCapacity: false)
//        objectArray.removeAll(keepCapacity: false)
//        
//        let slotUri = ApiURLManager.sharedInstance.returnObtainSlotsForDayURL(selectedDayInfos!.dayString!, month: selectedDayInfos!.monthString!, year: selectedDayInfos!.yearString!, idCapsuleLocation: String(stringInterpolationSegment: selectedCapsule!.idCapsuleLocation!))
//        if slotUri != "" {
//            usm.retrieveResourceForUri(slotUri, urlParametersDictionary: nil, completion: { (slotData, error) -> Void in
//                
//                if error == nil {
//                    
//                    if let timeSlotsDictionary = slotData.dictionary {
//                        
//                        if timeSlotsDictionary["count"]!.intValue > 0 {
//                            if let slotsArray = timeSlotsDictionary["creneaux"]!.array {
//                                
//                                for (currentSlot): (JSON) in slotsArray {
//                                    
//                                    let minutes           = currentSlot["local"]["minutes"].intValue
//                                    let hours             = currentSlot["local"]["hours"].intValue
//                                    let bookable          = currentSlot["bookable"].boolValue
//                                    let currency          = currentSlot["currency"].stringValue
//                                    let duration          = currentSlot["duration"].intValue
//                                    let dispoNumber       = currentSlot["dispo"].intValue
//                                    let price             = currentSlot["price"].doubleValue
//                                    //                                    let maxDispoNumber    = currentSlot["maxDispo"].intValue
//                                    
//                                    let slot = SlotObject(bookable: bookable, currency: currency, dispoNumber: dispoNumber, duration: duration, hours: hours, maxDispoNumber: dispoNumber, minutes: minutes, price: price, slotUri: "")
//                                    
//                                    if dispoNumber > 0 {
//                                        headerHourTextArray.append(slot.hours)
//                                        slotArray.append(slot)
//                                    }
//                                }
//                                
//                                let mySet           = Set<Int>(headerHourTextArray)
//                                headerHourTextArray = Array(mySet)
//                                headerHourTextArray.sortInPlace{$0 < $1}
//                                
//                                for headerHour in headerHourTextArray {
//                                    var tempSlotArray = [SlotObject]()
//                                    tempSlotArray.removeAll(keepCapacity: false)
//                                    for slot in slotArray {
//                                        if slot.hours == headerHour {
//                                            tempSlotArray.append(slot)
//                                        }
//                                    }
//                                    objectArray.append(Objects(sectionName: headerHour, sectionObjects: tempSlotArray))
//                                }
//                                completion(result: objectArray, error: nil, SlotsAvailable: true)
//                            }
//                        } else {
//                            completion(result: objectArray, error: nil, SlotsAvailable: false)
//                        }
//                    }
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:3, userInfo: [NSLocalizedDescriptionKey:"Game deletion failed"])
//            completion(result: objectArray, error: theError, SlotsAvailable: true)
//        }
//    }
//    
//    
//    //MARK: - COUPON
//    
//    internal func verifyCouponAvailibility(couponCode: String, completion: (coupon: Any, error: NSError?) -> Void) {
//        self.verifyCouponAvailibility(couponCode, userServiceManager: UserServiceManager.sharedInstance) {
//            (coupon, error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(coupon: coupon, error: error)
//            }
//        }
//    }
//    
//    private func verifyCouponAvailibility(couponCode: String, userServiceManager: UserServiceManager, completion: (coupon: Any, error: NSError?) -> Void) {
//        
//        let usm = userServiceManager
//        
//        let couponUri = ApiURLManager.sharedInstance.returnGetCouponInfosURL(couponCode)
//        
//        if couponUri != "" {
//            usm.retrieveResourceForUri(couponUri, urlParametersDictionary: nil, completion: { (couponData, error) -> Void in
//                if error == nil {
//                    if let aCoupon = couponData.dictionary {
//                        if aCoupon["error"]!.boolValue == false {
//                            let amount      = aCoupon["amount"]!.doubleValue
//                            let endTime     = Constants.serverDateFormat.dateFromString(aCoupon["endTime"]!.stringValue)
//                            let code        = aCoupon["code"]!.stringValue
//                            let libel       = aCoupon["name"]!.stringValue
//                            let startTime   = Constants.serverDateFormat.dateFromString(aCoupon["startTime"]!.stringValue)
//                            let logoUrl     = aCoupon["logo"]!.stringValue
//                            let currency    = aCoupon["currency"]!.stringValue
//                            
//                            let currentCoupon = Coupon(amount: amount, startTime: startTime!, endTime: endTime!, code: code, libel: libel, logoUrl: NSURL(string: logoUrl)!, currency: currency)
//                            
//                            completion(coupon: currentCoupon, error: nil)
//                        } else {
//                            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"coupon is not valid"])
//                            completion(coupon: "", error: theError)
//                        }
//                    } else {
//                        let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"coupon is not valid"])
//                        completion(coupon: "", error: theError)
//                    }
//                } else {
//                    let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"error retrieving ressources"])
//                    completion(coupon: "", error: theError)
//                }
//            })
//        } else {
//            let theError = NSError(domain: "UserServiceDataManager", code:2, userInfo: [NSLocalizedDescriptionKey:"no couponUri"])
//            completion(coupon: "", error: theError)
//        }
//    }
//    
//    
//    //MARK: - DELETE
//    
//    internal func deleteAllCapsulesFromDatabase(managedObjectContext: NSManagedObjectContext) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "Capsule")
//        
//        var capsules: [Capsule] = [Capsule]()
//        capsules = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Capsule]
//        
//        if capsules.count > 0 {
//            
//            for capsule in capsules {
//                
//                managedObjectContext.deleteObject(capsule)
//                
//                if capsule.deleted {
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    }
//                }
//            }
//            //            dispatch_async(dispatch_get_main_queue()) {
//            //                print("##########################")
//            //                print("#Capsule database deleted#")
//            //                print("##########################")
//            //            }
//        } else {
//            //            dispatch_async(dispatch_get_main_queue()) {
//            //                print("############################")
//            //                print("#Capsule database is empty#")
//            //                print("###########################")
//            //            }
//        }
//    }
//    
//    internal func deleteAllOpenDaysFromDatabase(managedObjectContext: NSManagedObjectContext) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "OpenDays")
//        
//        var openDays: [OpenDays] = [OpenDays]()
//        openDays = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [OpenDays]
//        
//        if openDays.count > 0 {
//            
//            for openDay in openDays {
//                
//                managedObjectContext.deleteObject(openDay)
//                
//                if openDay.deleted {
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    }
//                }
//            }
//            print("Open database deleted")
//        } else {
//            print("Open database is empty")
//        }
//    }
//    
//    internal func deleteAllPicturesFromDatabase(managedObjectContext: NSManagedObjectContext) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "Picture")
//        
//        var pictures: [Picture] = [Picture]()
//        pictures = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Picture]
//        
//        if pictures.count > 0 {
//            
//            for picture in pictures {
//                
//                managedObjectContext.deleteObject(picture)
//                
//                if picture.deleted {
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    }
//                }
//            }
//        }
//    }
//    
//    internal func deleteAllSlotsFromDatabase(managedObjectContext: NSManagedObjectContext) {
//        
//        let fetchRequest    = NSFetchRequest(entityName: "Slot")
//        
//        var slotArray       = [Slot]()
//        slotArray           = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Slot]
//        
//        if slotArray.count > 0 {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
//                for currentSlot in slotArray {
//                    
//                    managedObjectContext.deleteObject(currentSlot)
//                    
//                    if currentSlot.deleted {
//                        
//                        var saveError :NSError?
//                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                        
//                        if saveError == nil {
//                            CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    internal func deleteAllBooksFromDatabase(managedObjectContext: NSManagedObjectContext) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "Book")
//        
//        var book: [Book] = [Book]()
//        book = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Book]
//        
//        if book.count > 0 {
//            
//            for bk in book {
//                
//                managedObjectContext.deleteObject(bk)
//                
//                if bk.deleted {
//                    
//                    var saveError :NSError?
//                    CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    
//                    if saveError == nil {
//                        CoreDataStack.saveContext(managedObjectContext, error: &saveError)
//                    }
//                }
//            }
//            print("Book database deleted")
//        } else {
//            print("Book database is empty")
//        }
//    }
//    
//    
//}
