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

protocol ParkingSelectAble {
    func didSelectParking(parking: Parking)
}

class ParkingsDataSource: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Var & outlet
    
    private let tableView: UITableView
    
    public var parkingDelegate: ParkingSelectAble?
    
    
    // MARK: - View
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
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

    
    // MARK: - FetchedResultsController Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
}


// MARK: - UITableViewDataSource

extension ParkingsDataSource: UITableViewDataSource {
    
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
        parkingCell.setImageStatusWith()
        parkingCell.setNameLabelWith(name: parkingAtIndexPath.name ?? "No name")
        parkingCell.setAvailableLabelWith(availablePlaces: parkingAtIndexPath.available ?? "XX")
        
        guard let schedulesArray = parkingAtIndexPath.schedules.allObjects as? [Schedules] else {
            parkingCell.setOpenStatusLabelWith(isOpen: isOpen)
            tableViewCell = parkingCell
            return tableViewCell!
        }
        isOpen = SchedulesService.sharedInstance.parkingIsOpen(schedulesArray: schedulesArray, parkingStatus: parkingAtIndexPath.status ?? "0")
        parkingCell.setOpenStatusLabelWith(isOpen: isOpen)
        
        tableViewCell = parkingCell
        return tableViewCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.parkingDelegate?.didSelectParking(parking: parkingAtIndexPath(indexPath: indexPath as NSIndexPath))
    }
}


// MARK: - UITableViewDelegate

extension ParkingsDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
