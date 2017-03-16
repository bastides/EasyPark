// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Equipment.swift instead.

import Foundation
import CoreData

public enum EquipmentAttributes: String {
    case address = "address"
    case city = "city"
    case id_obj = "id_obj"
    case latitude = "latitude"
    case longitude = "longitude"
    case name = "name"
    case phone_number = "phone_number"
    case postal_code = "postal_code"
    case web = "web"
}

public enum EquipmentRelationships: String {
    case parking = "parking"
}

open class _Equipment: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Equipment"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<Equipment> {
        if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *) {
            return NSManagedObject.fetchRequest() as! NSFetchRequest<Equipment>
        } else {
            return NSFetchRequest(entityName: self.entityName())
        }
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Equipment.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var address: String?

    @NSManaged open
    var city: String?

    @NSManaged open
    var id_obj: String?

    @NSManaged open
    var latitude: Double // Optional scalars not supported

    @NSManaged open
    var longitude: Double // Optional scalars not supported

    @NSManaged open
    var name: String?

    @NSManaged open
    var phone_number: String?

    @NSManaged open
    var postal_code: String?

    @NSManaged open
    var web: String?

    // MARK: - Relationships

    @NSManaged open
    var parking: Parking?

    public class func allEquipmentsRequest(managedObjectContext: NSManagedObjectContext!) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [:]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "allEquipments", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchAllEquipments(managedObjectContext: NSManagedObjectContext) -> [Any]? {
        return self.fetchAllEquipments(managedObjectContext: managedObjectContext, error: nil)
    }

    class func fetchAllEquipments(managedObjectContext: NSManagedObjectContext, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [:]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "allEquipments", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"allEquipments\".")
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

    public class func equipmentForIdObjectRequest(managedObjectContext: NSManagedObjectContext!, id_obj: String) -> NSFetchRequest<NSFetchRequestResult> {

        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String:AnyObject] = [
        "id_obj": id_obj as AnyObject,
        ]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "equipmentForIdObject", substitutionVariables: substitutionVariables)!

        return fetchRequest
    }

    class func fetchEquipmentForIdObject(managedObjectContext: NSManagedObjectContext, id_obj: String) -> [Any]? {
        return self.fetchEquipmentForIdObject(managedObjectContext: managedObjectContext, id_obj: id_obj, error: nil)
    }

    class func fetchEquipmentForIdObject(managedObjectContext: NSManagedObjectContext, id_obj: String, error outError: NSErrorPointer) -> [Any]? {
        guard let psc = managedObjectContext.persistentStoreCoordinator else { return nil }
        let model = psc.managedObjectModel
        let substitutionVariables : [String : Any] = [
            "id_obj": id_obj,
]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "equipmentForIdObject", substitutionVariables: substitutionVariables) else {
        	assert(false, "Can't find fetch request named \"equipmentForIdObject\".")
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

