//
//  PlannedTripsViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

var PlannedTripsCellIdentifier = "PlannedTripsCell"

class PlannedTripsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var plannedTripsArrayDataSource: ArrayDataSource?
    
    var items = ["Berlin", "San Francisco", "Paris", "Takoradi", "London"]
    
    enum SegueDetail: String {
        case TripDetail = "TripDetail"
        case AddTrip = "AddTrip"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self

        setupCollectionView()
    }
    
    
     // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let direction = SegueDetail.TripDetail
        
        switch direction {
            case .TripDetail: break
                if let vc = segue.destinationViewController as? TripDetailViewController {
//                    vc.trip = items[(tableView.indexPathForSelectedRow?.row)!]
                }
                break
            case .AddTrip: break
        }
//        if segue.identifier == "TripDetail" {
//            if let vc = sender?.destinationViewController as? UIViewController {
//                
//            }
//        }
//        if segu
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

extension PlannedTripsViewController {
    
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

extension PlannedTripsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Push to next view controller
        performSegueWithIdentifier(SegueDetail.TripDetail.rawValue, sender: self)
    }
}