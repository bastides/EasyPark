// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Schedules.swift instead.

import Foundation
import CoreData

public enum SchedulesAttributes: String {
    case day = "day"
    case end_time = "end_time"
    case id_obj = "id_obj"
    case name = "name"
    case strat_time = "strat_time"
}

public enum SchedulesRelationships: String {
    case parking = "parking"
}

open class _Schedules: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Schedules"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<Schedules> {
        if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *) {
            return NSManagedObject.fetchRequest() as! NSFetchRequest<Schedules>
        } else {
            return NSFetchRequest(entityName: self.entityName())
        }
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Schedules.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var day: String?

    @NSManaged open
    var end_time: String?

    @NSManaged open
    var id_obj: String?

    @NSManaged open
    var name: String?

    @NSManaged open
    var strat_time: String?

    // MARK: - Relationships

    @NSManaged open
    var parking: Parking?

    public class func allSchedulesRequest(managedObjectContext: NSManagedObjectContext!) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [:]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "allSchedules", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchAllSchedules(managedObjectContext: NSManagedObjectContext) -> [Any]? {
        return self.fetchAllSchedules(managedObjectContext: managedObjectContext, error: nil)
    }

    class func fetchAllSchedules(managedObjectContext: NSManagedObjectContext, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [:]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "allSchedules", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"allSchedules\".")
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

    public class func schedulesForIdObjAndDayRequest(managedObjectContext: NSManagedObjectContext!, id_obj: String, day: String) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [
        "id_obj": id_obj as AnyObject,

        "day": day as AnyObject,
        ]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "schedulesForIdObjAndDay", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchSchedulesForIdObjAndDay(managedObjectContext: NSManagedObjectContext, id_obj: String, day: String) -> [Any]? {
        return self.fetchSchedulesForIdObjAndDay(managedObjectContext: managedObjectContext, id_obj: id_obj, day: day, error: nil)
    }

    class func fetchSchedulesForIdObjAndDay(managedObjectContext: NSManagedObjectContext, id_obj: String, day: String, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [
            "id_obj": id_obj,

            "day": day,
]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "schedulesForIdObjAndDay", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"schedulesForIdObjAndDay\".")
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

