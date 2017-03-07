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

}

