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
    
    var items = ["Berlin", "San Francisco", "Paris", "Takoradi", "London", "Accra", "Lome", "Lagos", "Kumasi"]
    
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

        setupCollectionView()
        layout()
    }
    
    
     // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        switch segue.identifier! {
            case SegueDetail.AddTrip.description: return
            case SegueDetail.TripDetail.description:
                if let vc = segue.destinationViewController as? TripDetailViewController {
//                    vc.trip = items[(collectionView.indexPathsForSelectedItems()[0].row)]
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

// MARK: - CollectionView Delegate

extension PlannedTripsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Push to next view controller
        performSegueWithIdentifier(SegueDetail.TripDetail.rawValue, sender: self)
    }
}

// MARK: - CollectionView Flow Layout

extension PlannedTripsViewController: UICollectionViewDelegateFlowLayout {
    
    func layout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = self.view.frame.size.width - 20
        
        let height:CGFloat = 200.0
        
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return sectionInsets
//        let leftRightInset = self.view.frame.size.width / 26
//       return UIEdgeInsetsMake(10, leftRightInset, 10, leftRightInset)
    }
}