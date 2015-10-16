//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/15/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol AddTripDelegate: class {
    
    func tripAddFinished(controller: AddTripViewController, trip: AnyObject)

}

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tripNameField: UITextField!
    
    enum DataError : ErrorType {
        case EmptyText
        // add more later
    }
    
    weak var tripAddDelegate: AddTripDelegate?
    var plannedTripsArrayDataSource: ArrayDataSource?
    var items = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTripPressed(sender: UIBarButtonItem) {
        do{
            try addTrip()
        }catch {
            SVProgressHUD.showErrorWithStatus("Error")
        }
    }
    /**
    Adds a trip and sends to delegate
    
    - throws: A DataError if text is empty
    */
    func addTrip() throws {
        
        guard let tripName = tripNameField.text else {
            throw DataError.EmptyText
        }
        
        tripAddDelegate?.tripAddFinished(self, trip: tripName)
    }
    
}

// MARK: - CollectionView DataSource

extension AddTripViewController {
    
    func setupCollectionView() {
        
        plannedTripsArrayDataSource = ArrayDataSource(items: items, cellIdentifier: PlannedTripsCellIdentifier,
            tableViewConfigureCallback: {
                (cell, item) -> () in
                
                if let actualCell = cell as? PlannedTripsCVCell {
                    if let actualItem = item as? String {
                        actualCell.configureCell(actualItem)
                    }
                }
        })
        collectionView.dataSource = plannedTripsArrayDataSource
        collectionView.registerNib(PlannedTripsCVCell.nib(), forCellWithReuseIdentifier: PlannedTripsCellIdentifier)
    }
}

