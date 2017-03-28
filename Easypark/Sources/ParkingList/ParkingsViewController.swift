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
    
    private var parkingsDataSource: ParkingsDataSource?
    
    private var refreshControl: UIRefreshControl!
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parkingsDataSource = ParkingsDataSource(tableView: self.parkingsTableView)
        self.parkingsTableView.dataSource = parkingsDataSource
        self.parkingsTableView.register(UINib(nibName: Constants.TableViewInfos.NIB_NAME, bundle: nil), forCellReuseIdentifier: Constants.TableViewInfos.CELL_IDENTIFIER)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: Constants.RefreshControlInfos.ATTRIBUTED_TITLE)
        self.refreshControl.addTarget(self, action: #selector(ParkingsViewController.handleRefresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            self.parkingsTableView.refreshControl = self.refreshControl
        } else {
            self.parkingsTableView.addSubview(self.refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - View
    
    public func handleRefresh() {
        guard let moc = CoreDataStack.sharedInstance.managedObjectContext else {
            print("ManagedObjectContext instantiation failed in ContextManager")
            return
        }
        StorageManager.sharedInstance.persistSchedules(moc: moc) { }
        StorageManager.sharedInstance.persistParking(moc: moc)
        self.refreshControl.endRefreshing()
    }


    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Constants.TableViewInfos.SEGUE_IDENTIFIER {
//            
//        }
//    }
}
