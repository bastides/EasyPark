// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Parking.swift instead.

import Foundation
import CoreData

public enum ParkingAttributes: String {
    case available = "available"
    case exploitation = "exploitation"
    case full = "full"
    case horodatage = "horodatage"
    case identifier = "identifier"
    case name = "name"
    case pri_aut = "pri_aut"
    case status = "status"
}

open class _Parking: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Parking"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<Parking> {
        if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *) {
            return NSManagedObject.fetchRequest() as! NSFetchRequest<Parking>
        } else {
            return NSFetchRequest(entityName: self.entityName())
        }
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Parking.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var available: String?

    @NSManaged open
    var exploitation: String?

    @NSManaged open
    var full: String?

    @NSManaged open
    var horodatage: String?

    @NSManaged open
    var identifier: String?

    @NSManaged open
    var name: String?

    @NSManaged open
    var pri_aut: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    public class func parkingForNameRequest(managedObjectContext: NSManagedObjectContext!, name: String) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [
        "name": name as AnyObject,
        ]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "parkingForName", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchParkingForName(managedObjectContext: NSManagedObjectContext, name: String) -> [Any]? {
        return self.fetchParkingForName(managedObjectContext: managedObjectContext, name: name, error: nil)
    }

    class func fetchParkingForName(managedObjectContext: NSManagedObjectContext, name: String, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [
            "name": name,
]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "parkingForName", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"parkingForName\".")
		return nil
	}
        var results = Array<Any>()
        do {
             results = try managedObjectContext.fetch(fetchRequest)
        } catch {
          print("Error executing fetch request: \(error)")
        }

        return results
    }

    public class func allParkingsRequest(managedObjectContext: NSManagedObjectContext!) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [:]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "allParkings", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchAllParkings(managedObjectContext: NSManagedObjectContext) -> [Any]? {
        return self.fetchAllParkings(managedObjectContext: managedObjectContext, error: nil)
    }

    class func fetchAllParkings(managedObjectContext: NSManagedObjectContext, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [:]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "allParkings", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"allParkings\".")
		return nil
	}
        var results = Array<Any>()
        do {
             results = try managedObjectContext.fetch(fetchRequest)
        } catch {
          print("Error executing fetch request: \(error)")
        }

        return results
    }

}

