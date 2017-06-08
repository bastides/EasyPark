//
//  StorageManager.swift
//  Easypark
//
//  Created by Sebastien Bastide on 06/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import Foundation
import CoreData
import EasyparkModel

class StorageManager: NSObject {

    public static let sharedInstance = StorageManager()
    
    // MARK: - Parking
    
    public func persistParking(moc: NSManagedObjectContext, onSuccess: @escaping () -> Void, onError: @escaping (_ error: NSError?) -> Void) {
        self.persistingParking(managedObjectContext: moc, onSuccess: {
            onSuccess()
        }) { _ in }
    }
    
    private func persistingParking(managedObjectContext: NSManagedObjectContext, onSuccess: @escaping () -> Void, onError: @escaping (_ error: NSError?) -> Void) {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PARKING_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { (jsonParkingsData, error) -> Void in
                if error == nil {
                    var tempMoc: NSManagedObjectContext?
                    do {
                        tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                    } catch  {
                        let errorTempMoc = NSError(domain: "StorageManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "TempMoc error"])
                        onError(errorTempMoc)
                    }
                    
                    guard let groupesParkingDictionary = jsonParkingsData["opendata"]["answer"]["data"]["Groupes_Parking"].dictionary else {
                        return
                    }
                    guard let groupeParkingArray = groupesParkingDictionary["Groupe_Parking"]?.array else {
                        return
                    }
                    
                    for parking in groupeParkingArray {
                        var currentParking = Parking.parkingForIdObj(idObject: parking["IdObj"].stringValue, moc: tempMoc!)
                        if currentParking == nil {
                            currentParking = Parking(managedObjectContext: tempMoc!)
                        }
                        currentParking?.available = parking["Grp_disponible"].stringValue
                        currentParking?.exploitation = parking["Grp_exploitation"].stringValue
                        currentParking?.full = parking["Grp_complet"].stringValue
                        currentParking?.horodatage = parking["Grp_horodatage"].stringValue
                        currentParking?.id_obj = parking["IdObj"].stringValue
                        currentParking?.identifier = parking["Grp_identifiant"].stringValue
                        currentParking?.name = parking["Grp_nom"].stringValue
                        currentParking?.pri_aut = parking["Grp_pri_aut"].stringValue
                        currentParking?.status = parking["Grp_statut"].stringValue
                        
                        guard let equipmentsArray = Equipment.allEquipments(moc: tempMoc!) else { return }
                        for equipment in equipmentsArray {
                            if equipment.id_obj == parking["IdObj"].stringValue {
                                currentParking?.equipment = equipment
                            }
                        }
                        
                        guard let schedulesArray = Schedules.allSchedules(moc: tempMoc!) else { return }
                        for schedules in schedulesArray {
                            if schedules.id_obj == parking["IdObj"].stringValue {
                                guard let day = schedules.day else { return }
                                guard let currentSchedules = Schedules.schedulesForIdObjAndDay(idObject: parking["IdObj"].stringValue, day: day, moc: tempMoc!) else {
                                    currentParking?.addSchedulesObject(schedules)
                                    return
                                }
                                currentParking?.removeSchedulesObject(currentSchedules)
                                currentParking?.addSchedulesObject(schedules)
                            }
                        }
                    }
                    
                    defer {
                        var saveError: NSError?
                        CoreDataStack.saveContext(managedObjectContext: tempMoc, error: &saveError)
                        if saveError == nil {
                            CoreDataStack.saveContext(managedObjectContext: managedObjectContext, error: &saveError)
                            onSuccess()
                        } else {
                            onError(saveError)
                        }
                    }

                }
                onError(error)
           })
        }
    }
    
    
    // MARK: - Schedules
    
    public func persistSchedules(moc: NSManagedObjectContext, completion: @escaping (_ error: NSError?) -> Void) {
        self.persistingSchedules(managedObjectContext: moc) { error in
            completion(error)
        }
    }
    
    private func persistingSchedules(managedObjectContext: NSManagedObjectContext, completion: @escaping (_ error: NSError?) -> Void) {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PARKING_SCHEDULES_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { (jsonSchedulesData, error) -> Void in
                if error == nil {
                    var tempMoc: NSManagedObjectContext?
                    do {
                        tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                    } catch {
                        let errorTempMoc = NSError(domain: "StorageManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "TempMoc error"])
                        completion(errorTempMoc)
                    }
                    
                    guard let schedulesArray = jsonSchedulesData["data"].array else {
                        return
                    }
                    
                    for schedules in schedulesArray {
                        var currentSchedules = Schedules.schedulesForIdObjAndDay(idObject: schedules["_IDOBJ"].stringValue, day: schedules["JOUR"].stringValue, moc: managedObjectContext)
                        
                        if currentSchedules == nil {
                            currentSchedules = Schedules(context: tempMoc!)
                        }
                        currentSchedules?.day = schedules["JOUR"].stringValue
                        currentSchedules?.end_time = schedules["HEURE_FIN"].stringValue
                        currentSchedules?.id_obj = schedules["_IDOBJ"].stringValue
                        currentSchedules?.name = schedules["NOM_COMPLET"].stringValue
                        currentSchedules?.strat_time = schedules["HEURE_DEBUT"].stringValue
                    }
                    
                    defer {
                        var saveError: NSError?
                        CoreDataStack.saveContext(managedObjectContext: tempMoc, error: &saveError)
                        if saveError == nil {
                            CoreDataStack.saveContext(managedObjectContext: managedObjectContext, error: &saveError)
                            completion(saveError)
                        } else {
                            completion(saveError)
                        }
                    }
                }
                completion(error)
            })
        }
    }

    
    // MARK: - Equipment
    
    public func persistEquipment(moc: NSManagedObjectContext, completion: @escaping (_ error: NSError?) -> Void) {
        self.persistingEquipment(managedObjectContext: moc) { error in
            completion(error)
        }
    }
    
    private func persistingEquipment(managedObjectContext: NSManagedObjectContext, completion: @escaping (_ error: NSError?) -> Void) {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PUBLIC_EQUIPMENTS_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { (jsonEquipmentsData, error) -> Void in
                if error == nil {
                    var tempMoc: NSManagedObjectContext?
                    do {
                        tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                    } catch {
                        let errorTempMoc = NSError(domain: "StorageManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "TempMoc error"])
                        completion(errorTempMoc)
                    }
                    
                    guard let equipmentArray = jsonEquipmentsData["data"].array else {
                        return
                    }
                    
                    for equipment in equipmentArray {
                        var currentEquipment = Equipment.equipmentForIdObj(idObject: equipment["_IDOBJ"].stringValue, moc: managedObjectContext)
                        
                        if currentEquipment == nil {
                            currentEquipment = Equipment(context: tempMoc!)
                        }
                        
                        currentEquipment?.address = equipment["ADRESSE"].stringValue
                        currentEquipment?.city = equipment["COMMUNE"].stringValue
                        currentEquipment?.id_obj = equipment["_IDOBJ"].stringValue
                        currentEquipment?.latitude = equipment["_l"][0].doubleValue
                        currentEquipment?.longitude = equipment["_l"][1].doubleValue
                        currentEquipment?.name = equipment["geo"]["name"].stringValue
                        currentEquipment?.phone_number = equipment["TELEPHONE"].stringValue
                        currentEquipment?.postal_code = equipment["CODE_POSTAL"].stringValue
                        currentEquipment?.web = equipment["WEB"].stringValue
                    }
                    
                    defer {
                        var saveError: NSError?
                        CoreDataStack.saveContext(managedObjectContext: tempMoc, error: &saveError)
                        if saveError == nil {
                            CoreDataStack.saveContext(managedObjectContext: managedObjectContext, error: &saveError)
                            completion(saveError)
                        } else {
                            completion(saveError)
                        }
                    }
                }
                completion(error)
            })
        }
    }
}
