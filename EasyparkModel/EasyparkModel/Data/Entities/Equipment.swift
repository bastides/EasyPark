import Foundation
import CoreData

@objc(Equipment)
open class Equipment: _Equipment {
	
    public class func equipmentForIdObj(idObject: String, moc: NSManagedObjectContext) -> Equipment? {
        var currentEquipment: Equipment?
        if let equipmentArray = Equipment.fetchEquipmentForIdObject(managedObjectContext: moc, id_obj: idObject) as NSArray? {
            if equipmentArray.count > 0 {
                currentEquipment = equipmentArray[0] as? Equipment
            }
        }
        return currentEquipment
    }
    
    public class func allEquipments(moc: NSManagedObjectContext) -> [Equipment]? {
        var equipmentList: [Equipment]?
        if let equipmentArray = Equipment.fetchAllEquipments(managedObjectContext: moc) as NSArray? {
            if equipmentArray.count > 0 {
                equipmentList = equipmentArray as? [Equipment]
            }
        }
        return equipmentList
    }
}
