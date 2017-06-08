//
//  ParkingsViewController.swift
//  Easypark
//
//  Created by Sebastien Bastide on 11/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import UIKit
import EasyparkModel

class ParkingsViewController: UIViewController {

    // MARK: - Var & outlet
    
    @IBOutlet var parkingsTableView: UITableView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var parkingsDataSource: ParkingsDataSource?
    private var refreshControl: UIRefreshControl!
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let moc = CoreDataStack.sharedInstance.managedObjectContext else {
            print("ManagedObjectContext instantiation failed in ContextManager")
            return
        }
        StorageManager.sharedInstance.persistSchedules(moc: moc) { _ in }
        StorageManager.sharedInstance.persistEquipment(moc: moc) { _ in }
        StorageManager.sharedInstance.persistParking(moc: moc, onSuccess: {
            self.hideWaitingView()
        }) { _ in }
        
        
        self.parkingsDataSource = ParkingsDataSource(tableView: self.parkingsTableView)
        self.parkingsTableView.dataSource = parkingsDataSource
        self.parkingsTableView.register(UINib(nibName: Constants.TableViewInfos.NIB_NAME, bundle: nil), forCellReuseIdentifier: Constants.TableViewInfos.CELL_IDENTIFIER)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: Constants.RefreshControlInfos.ATTRIBUTED_TITLE)
        self.refreshControl.addTarget(self, action: #selector(ParkingsViewController.handleRefresh), for: .valueChanged)
        
        self.parkingsDataSource?.parkingDelegate = self
        
        if #available(iOS 10.0, *) {
            self.parkingsTableView.refreshControl = self.refreshControl
        } else {
            self.parkingsTableView.addSubview(self.refreshControl)
        }
    }
    
    
    // MARK: - View
    
    public func handleRefresh() {
        guard let moc = CoreDataStack.sharedInstance.managedObjectContext else {
            print("ManagedObjectContext instantiation failed in ContextManager")
            return
        }
        StorageManager.sharedInstance.persistSchedules(moc: moc) { _ in }
        StorageManager.sharedInstance.persistParking(moc: moc, onSuccess: { _ in }, onError: { _ in })
        self.refreshControl.endRefreshing()
    }
    
    private func hideWaitingView() {
        self.activityIndicator.stopAnimating()
        self.waitingView.isHidden = true
    }
}


// MARK: - ParkingSelectAble

extension ParkingsViewController: ParkingSelectAble {
    
    func didSelectParking(parking: Parking) {
        let parkingInfosViewController = ParkingInfosViewController(parking: parking)
        self.navigationController?.pushViewController(parkingInfosViewController, animated: true)
    }
}
