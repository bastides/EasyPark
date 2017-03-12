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
        
        let url = Constants.parkingsInformationsUrlRequest
        
        if url != "" {
            parkingsService.getJsonDisponibiliteParkings(url: url, callback: { JsonParkingsData in
                
                var tempMoc: NSManagedObjectContext?
                do {
                    tempMoc = try CoreDataStack.temporaryManagedObjectContextWithParent(moc: managedObjectContext)
                } catch {
                    print("Erreur tempMoc")
                }

                if let parkingsDictionnary = JsonParkingsData.dictionary {
                    if let opendataDictionary = parkingsDictionnary["opendata"]?.dictionary {
                        if let answerDictionary = opendataDictionary["answer"]?.dictionary {
                            if let dataDictionary = answerDictionary["data"]?.dictionary {
                                if let groupesParkingDictionary = dataDictionary["Groupes_Parking"]?.dictionary {
                                    if let groupeParkingArray = groupesParkingDictionary["Groupe_Parking"]?.array {
                                        for parking in groupeParkingArray {
                                            var currentParking = Parking.parkingForName(name: parking["Grp_nom"].stringValue, moc: managedObjectContext)
                                            if currentParking == nil {
                                                currentParking = Parking(managedObjectContext: tempMoc!)
                                            }
                                            currentParking?.available = parking["Grp_disponible"].stringValue
                                            currentParking?.exploitation = parking["Grp_exploitation"].stringValue
                                            currentParking?.full = parking["Grp_complet"].stringValue
                                            currentParking?.horodatage = parking["Grp_horodatage"].stringValue
                                            currentParking?.identifier = parking["Grp_identifiant"].stringValue
                                            currentParking?.name = parking["Grp_nom"].stringValue
                                            currentParking?.pri_aut = parking["Grp_pri_aut"].stringValue
                                            currentParking?.status = parking["Grp_statut"].stringValue
                                      }
                                    }
                                }
                            }
                        }
                    }
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
    
    public func fetchAllParkings(managedObjectContext: NSManagedObjectContext) -> [String] {
        return self.fetchingAllParkings(managedObjectContext: managedObjectContext)
    }
    
    private func fetchingAllParkings(managedObjectContext: NSManagedObjectContext) -> [String] {
        var allParkings = [String]()
        guard let parkingList = Parking.allParkings(moc: managedObjectContext) else {
            print("No parking")
            return allParkings
        }
        for parking in parkingList {
            allParkings.append(parking.name ?? "No name")
        }
        return allParkings
    }
}
