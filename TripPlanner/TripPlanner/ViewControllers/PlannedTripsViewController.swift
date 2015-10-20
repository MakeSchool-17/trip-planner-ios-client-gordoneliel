//
//  PlannedTripsViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import AVFoundation

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
        
//        if let layout = collectionView?.collectionViewLayout as? PlannedTripViewLayout {
//            layout.delegate = self
//        }
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

extension PlannedTripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width - 40
        
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(20)
    }
}

//extension PlannedTripsViewController : PinterestLayoutDelegate {
//    // 1
//    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
//        withWidth width:CGFloat) -> CGFloat {
//            let photo = UIImage(named: "village_houses")
//            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//            let rect  = AVMakeRectWithAspectRatioInsideRect(photo!.size, boundingRect)
//            return rect.size.height
////            return CGFloat(200)
//    }
//    
//    // 2
//    func collectionView(collectionView: UICollectionView,
//        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
////            let annotationPadding = CGFloat(4)
////            let annotationHeaderHeight = CGFloat(17)
////            let photo = photos[indexPath.item]
////            let font = UIFont(name: "AvenirNext-Regular", size: 10)!
////            let commentHeight = photo.heightForComment(font, width: width)
////            let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
////            return height
//            return CGFloat(100)
//    }
//}

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