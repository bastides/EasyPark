import Foundation
import CoreData

@objc(Schedules)
open class Schedules: _Schedules {
	
    public class func schedulesForIdObjAndDay(idObject: String, day: String, moc: NSManagedObjectContext) -> Schedules? {
        var currentSchedules: Schedules?
        if let schedulesArray = Schedules.fetchSchedulesForIdObjAndDay(managedObjectContext: moc, id_obj: idObject, day: day) as NSArray? {
            if schedulesArray.count > 0 {
                currentSchedules = schedulesArray[0] as? Schedules
            }
        }
        return currentSchedules
    }
    
    public class func allSchedules(moc: NSManagedObjectContext) -> [Schedules]? {
        var schedulesList: [Schedules]?
        if let schedulesArray = Schedules.fetchAllSchedules(managedObjectContext: moc) as NSArray? {
            if schedulesArray.count > 0 {
                schedulesList = schedulesArray as? [Schedules]
            }
        }
        return schedulesList
    }
}
