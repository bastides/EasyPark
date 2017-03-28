//
//  ParkingsDataSource.swift
//  Easypark
//
//  Created by Sebastien Bastide on 11/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//
	
import Foundation
import UIKit
import CoreData
import EasyparkModel

class ParkingsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Var & outlet
    
    private let tableView: UITableView
    
    
    // MARK: - View
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func parkingAtIndexPath(indexPath: NSIndexPath) -> Parking {
        let parking = fetchedResultsController.object(at: indexPath as IndexPath) as! Parking
        return parking
    }
    
    
    // MARK: - NSFetchedRusultsController
    
    private var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = self.request()
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        
        var error: NSError? = nil
        do {
            try aFetchedResultsController.performFetch()
        }catch let error1 as NSError {
            error = error1
            print(error ?? "Error")
        }
        
        _fetchedResultsController = aFetchedResultsController
        
        return _fetchedResultsController!
    }
    
    func request() -> NSFetchRequest<NSFetchRequestResult> {
        let moc = CoreDataStack.sharedInstance.managedObjectContext!
        let request: NSFetchRequest<Parking> = Parking.allParkingsRequest(managedObjectContext: moc) as! NSFetchRequest<Parking>
        let sortKey = ParkingAttributes.name.rawValue
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell?
        var isOpen: Bool? = nil
        let parkingAtIndexPath = self.parkingAtIndexPath(indexPath: indexPath as NSIndexPath)
        let parkingCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewInfos.CELL_IDENTIFIER) as! ParkingTableViewCell
        parkingCell.setImageStatusWith(availablePlaces: parkingAtIndexPath.available ?? "0", exploitationPlaces: parkingAtIndexPath.exploitation ?? "0")
        parkingCell.setNameLabelWith(name: parkingAtIndexPath.name ?? "No name")
        parkingCell.setAvailableLabelWith(availablePlaces: parkingAtIndexPath.available ?? "XX")
        
        guard let schedulesArray = parkingAtIndexPath.schedules.allObjects as? [Schedules], schedulesArray != [] else {
            parkingCell.setOpenStatusLabelWith(isOpen: isOpen)
            tableViewCell = parkingCell
            return tableViewCell!
        }
        isOpen = SchedulesService.sharedInstance.parkingIsOpen(schedulesArray: schedulesArray, parkingStatus: parkingAtIndexPath.status ?? "0")
        parkingCell.setOpenStatusLabelWith(isOpen: isOpen)
        
        tableViewCell = parkingCell
        return tableViewCell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
    // MARK: - FetchedResultsController Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
}
