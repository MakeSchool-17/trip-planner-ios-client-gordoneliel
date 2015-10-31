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
    
    var trip: Trip?
    var tripDetailArrayDataSource: ArrayDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        setupTableView()
    }
}

extension TripDetailViewController {
    func setupTableView() {
        
        tripDetailArrayDataSource = ArrayDataSource(items: [trip!], cellIdentifier: PlannedTripsCellIdentifier,
            cellConfigureCallback: {
                (cell, item) -> () in
                
                if let actualCell = cell as? PlannedTripsCVCell {
                    if let actualItem = item as? Trip {
                        actualCell.configureCell(actualItem)
                    }
                }
        })
        collectionView.dataSource = tripDetailArrayDataSource
        collectionView.registerNib(PlannedTripsCVCell.nib(), forCellWithReuseIdentifier: PlannedTripsCellIdentifier)
        collectionView.registerNib(PlannedTripHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PlannedTripsHeaderView")
    }
}

extension TripDetailViewController: UICollectionViewDelegate {
    
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