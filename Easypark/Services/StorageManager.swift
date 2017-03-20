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
    
    public func persistParking(moc: NSManagedObjectContext) -> Void {
        self.persistingParking(managedObjectContext: moc)
    }
    
    private func persistingParking(managedObjectContext: NSManagedObjectContext) -> Void {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PARKING_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { JsonParkingsData in
                
                var tempMoc: NSManagedObjectContext?
                do {
                    tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                } catch {
                    print("Erreur tempMoc")
                }

                guard let groupesParkingDictionary = JsonParkingsData["opendata"]["answer"]["data"]["Groupes_Parking"].dictionary else {
                    return
                }
                guard let groupeParkingArray = groupesParkingDictionary["Groupe_Parking"]?.array else {
                    return
                }
                for parking in groupeParkingArray {
                    var currentParking = Parking.parkingForIdObj(idObject: parking["IdObj"].stringValue, moc: managedObjectContext)
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
                }
                
                defer {
                    var saveError: NSError?
                    CoreDataStack.saveContext(managedObjectContext: tempMoc, error: &saveError)
                    if saveError == nil {
                        CoreDataStack.saveContext(managedObjectContext: managedObjectContext, error: &saveError)
                    }
                }
            })
        }
    }
    
//    public func fetchAllParkings(managedObjectContext: NSManagedObjectContext) -> [String] {
//        return self.fetchingAllParkings(managedObjectContext: managedObjectContext)
//    }
//    
//    private func fetchingAllParkings(managedObjectContext: NSManagedObjectContext) -> [String] {
//        var allParkings = [String]()
//        guard let parkingList = Parking.allParkings(moc: managedObjectContext) else {
//            print("No parking")
//            return allParkings
//        }
//        for parking in parkingList {
//            allParkings.append(parking.name ?? "No name")
//        }
//        return allParkings
//    }
    
    public func fetchAllParkingsIdObj(managedObjectContext: NSManagedObjectContext) -> [String] {
        return self.fetchingAllParkingsIdObj(managedObjectContext: managedObjectContext)
    }
    
    private func fetchingAllParkingsIdObj(managedObjectContext: NSManagedObjectContext) -> [String] {
        var idObjArray = [String]()
        guard let parkingsList = Parking.allParkings(moc: managedObjectContext) else {
            print("No Parking")
            return idObjArray
        }
        for parking in parkingsList {
            idObjArray.append(parking.id_obj ?? "No IdObj")
        }
        
        return idObjArray
    }
    
    
    // MARK: - Schedules
    
    public func persistSchedules(moc: NSManagedObjectContext) {
        self.persistingSchedules(managedObjectContext: moc)
    }
    
    private func persistingSchedules(managedObjectContext: NSManagedObjectContext) {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PARKING_SCHEDULES_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { JsonParkingsData in
                
                var tempMoc: NSManagedObjectContext?
                do {
                    tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                } catch {
                    print("Erreur tempMoc")
                }
                
                guard let schedulesArray = JsonParkingsData["data"].array else {
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
                    }
                }
            })
        }
    }
    
//    public func fetchAllSchedulesIdObj(managedObjectContext: NSManagedObjectContext) -> [String] {
//        return self.fetchingAllSchedulesIdObj(managedObjectContext: managedObjectContext)
//    }
//    
//    private func fetchingAllSchedulesIdObj(managedObjectContext: NSManagedObjectContext) -> [String] {
//        var allSchedulesIdObjArray = [String]()
//        var uniqueIdObjArray = [String]()
//        guard let schedulesList = Schedules.allSchedules(moc: managedObjectContext) else {
//            print("No Schedules")
//            return uniqueIdObjArray
//        }
//        for schedules in schedulesList {
//            allSchedulesIdObjArray.append(schedules.id_obj ?? "No IdObj")
//        }
//        
//        for uniqueIdObj in allSchedulesIdObjArray {
//            if uniqueIdObjArray.contains(uniqueIdObj) == false {
//                uniqueIdObjArray.append(uniqueIdObj)
//            }
//        }
//        
//        return uniqueIdObjArray
//    }

    
    // MARK: - Equipment
    
    public func persistEquipment(moc: NSManagedObjectContext) -> Void {
        self.persistingEquipment(managedObjectContext: moc)
    }
    
    private func persistingEquipment(managedObjectContext: NSManagedObjectContext) -> Void {
        let parkingsService = ParkingsService.sharedInstance
        let url = Constants.PUBLIC_EQUIPMENTS_URL_REQUEST
        
        if url != "" {
            parkingsService.getJsonData(url: url, callback: { JsonEquipmentsData in
                
                var tempMoc: NSManagedObjectContext?
                do {
                    tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                } catch {
                    print("Erreur tempMoc")
                }
                
                guard let equipmentArray = JsonEquipmentsData["data"].array else {
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
                    }
                }
            })
        }
    }
    
//    public func fetchAllEquipments(managedObjectContext: NSManagedObjectContext) -> [Double] {
//        return self.fetchingAllAllEquipments(managedObjectContext: managedObjectContext)
//    }
//    
//    private func fetchingAllAllEquipments(managedObjectContext: NSManagedObjectContext) -> [Double] {
//        var allEquipments = [Double]()
//        guard let equipmentList = Equipment.allEquipments(moc: managedObjectContext) else {
//            print("No Equipment")
//            return allEquipments
//        }
//        for equipment in equipmentList {
//            allEquipments.append(equipment.latitude)
//        }
//        return allEquipments
//    }
}
