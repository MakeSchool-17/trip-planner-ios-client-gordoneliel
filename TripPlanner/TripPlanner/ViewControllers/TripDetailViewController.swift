//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var trip: String?
    var tripDetailArrayDataSource: ArrayDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        if trip == nil {
            trip = "Berlin"
        }
//        setupTableView()
    }
}

extension TripDetailViewController {
    func setupTableView() {
        
        tripDetailArrayDataSource = ArrayDataSource(items: [trip!], cellIdentifier: PlannedTripsCellIdentifier,
            cellConfigureCallback: {
                (cell, item) -> () in
                
                if let actualCell = cell as? PlannedTripsTVCell {
                    if let actualItem = item as? String {
                        actualCell.configureCell(actualItem)
                    }
                }
        })
        collectionView.dataSource = tripDetailArrayDataSource
        collectionView.registerNib(PlannedTripsCVCell.nib(), forCellWithReuseIdentifier: PlannedTripsCellIdentifier)
    }
}

extension TripDetailViewController: UICollectionViewDelegate {
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = PlannedTripsTVCell()
//        cell.configureCell(trip!)
//        return cell.contentView
//    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
}