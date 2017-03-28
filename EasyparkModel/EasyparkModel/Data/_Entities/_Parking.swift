// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Parking.swift instead.

import Foundation
import CoreData

public enum ParkingAttributes: String {
    case available = "available"
    case exploitation = "exploitation"
    case full = "full"
    case horodatage = "horodatage"
    case id_obj = "id_obj"
    case identifier = "identifier"
    case name = "name"
    case pri_aut = "pri_aut"
    case status = "status"
}

public enum ParkingRelationships: String {
    case equipment = "equipment"
    case schedules = "schedules"
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
    var id_obj: String?

    @NSManaged open
    var identifier: String?

    @NSManaged open
    var name: String?

    @NSManaged open
    var pri_aut: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    @NSManaged open
    var equipment: Equipment?

    @NSManaged open
    var schedules: NSSet

    open func schedulesSet() -> NSMutableSet {
        return self.schedules.mutableCopy() as! NSMutableSet
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

    public class func parkingForIdObjRequest(managedObjectContext: NSManagedObjectContext!, id_obj: String) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [
        "id_obj": id_obj as AnyObject,
        ]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "parkingForIdObj", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchParkingForIdObj(managedObjectContext: NSManagedObjectContext, id_obj: String) -> [Any]? {
        return self.fetchParkingForIdObj(managedObjectContext: managedObjectContext, id_obj: id_obj, error: nil)
    }

    class func fetchParkingForIdObj(managedObjectContext: NSManagedObjectContext, id_obj: String, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [
            "id_obj": id_obj,
]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "parkingForIdObj", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"parkingForIdObj\".")
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

extension _Parking {

    open func addSchedules(_ objects: NSSet) {
        let mutable = self.schedules.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.schedules = mutable.copy() as! NSSet
    }

    open func removeSchedules(_ objects: NSSet) {
        let mutable = self.schedules.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.schedules = mutable.copy() as! NSSet
    }

    open func addSchedulesObject(_ value: Schedules) {
        let mutable = self.schedules.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.schedules = mutable.copy() as! NSSet
    }

    open func removeSchedulesObject(_ value: Schedules) {
        let mutable = self.schedules.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.schedules = mutable.copy() as! NSSet
    }

}

