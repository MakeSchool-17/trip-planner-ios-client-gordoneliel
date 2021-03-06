//
//  PlannedTripsViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

var PlannedTripsCellIdentifier = "PlannedTripsCell"

class PlannedTripsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var plannedTripsArrayDataSource: ArrayDataSource?
    var trips :[Trip] = []
    
    var managedObjectContext = CoreDataStack().managedObjectContext
    
    enum SegueDetail: String {
        case TripDetail = "TripDetail"
        case AddTrip = "AddTrip"
        
        var description: String {
            switch(self) {
            case .TripDetail:
                return "TripDetail"
            case .AddTrip:
                return "AddTrip"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getTrips()
        setupCollectionView()
    }
    
    /**
     Fetch Trips from API
     */
    func getTrips() {
        SVProgressHUD.show()
        trips = CoreDataClient(managedObjectContext: managedObjectContext).allTrips()
        collectionView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func refreshTrips(sender: AnyObject) {
        SVProgressHUD.show()
        CoreDataSync(managedObjectContext: managedObjectContext).sync { result in
            self.trips = result
            self.setupCollectionView()
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }
        
    }
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case SegueDetail.AddTrip.description:
            if let addTripVC = segue.destinationViewController as? UINavigationController {
                let vc = addTripVC.topViewController as? AddTripViewController
                vc!.tripAddDelegate = self
            }
            
        case SegueDetail.TripDetail.description:
            if let vc = segue.destinationViewController as? TripDetailViewController {
                vc.trip = trips[(collectionView.indexPathsForSelectedItems()![0].row)]
                
            }
        default: return
        }
    }
    
    @IBAction func cancelToPlannedTrips(segue:UIStoryboardSegue) {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

// MARK: - CollectionView DataSource

extension PlannedTripsViewController {
    
    func setupCollectionView() {
        plannedTripsArrayDataSource = ArrayDataSource(items: trips, cellIdentifier: PlannedTripsCellIdentifier,
            cellConfigureCallback: {
                (cell, item) -> () in
                
                if let actualCell = cell as? PlannedTripsCVCell {
                    if let actualItem = item as? Trip {
                        actualCell.configureCell(actualItem)
                    }
                }
        })
        collectionView.dataSource = plannedTripsArrayDataSource
        collectionView.registerNib(PlannedTripsCVCell.nib(), forCellWithReuseIdentifier: PlannedTripsCellIdentifier)
    }
}

extension PlannedTripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width - 20
        
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(20)
    }
}

// MARK: - CollectionView Delegate

extension PlannedTripsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Push to next view controller
        performSegueWithIdentifier(SegueDetail.TripDetail.rawValue, sender: self)
    }
}

// MARK: AddTrip Delegate

extension PlannedTripsViewController: AddTripDelegate {
    func tripAddFinished(controller: AddTripViewController, trip: AnyObject) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
}