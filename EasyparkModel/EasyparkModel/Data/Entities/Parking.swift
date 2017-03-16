import Foundation
import CoreData

@objc(Parking)
open class Parking: _Parking {
    
    public class func parkingForIdObj(idObject: String, moc: NSManagedObjectContext) -> Parking? {
        var currentParking: Parking?
        if let parkingArray = Parking.fetchParkingForIdObj(managedObjectContext: moc, id_obj: idObject) as NSArray? {
            if parkingArray.count > 0 {
                currentParking = parkingArray[0] as? Parking
            }
        }
        return currentParking
    }   

    
//    public class func allParkings(moc: NSManagedObjectContext) -> [Parking]? {
//        var parkingList: [Parking]?
//        if let parkingArray = Parking.fetchAllParkings(managedObjectContext: moc) as NSArray? {
//            if parkingArray.count > 0 {
//                parkingList = parkingArray as? [Parking]
//            }
//        }
//        return parkingList
//    }
}
