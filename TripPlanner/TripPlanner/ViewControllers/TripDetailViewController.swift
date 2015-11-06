//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    @IBOutlet var presentTripView: PresentTripView!
    @IBOutlet var emptyTripView: EmptyTripView!
    
    var trip: Trip?
    var tripDetailArrayDataSource: ArrayDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewToPresent()
    }
    
    /**
     Presents a view based on whether a user has trips or not
     */
    func viewToPresent() {
        
        guard let trip = trip else {return}
        guard let waypoints = trip.waypoints else {return}
        let frame = self.view.frame
        
        if waypoints.count == 0 {
            emptyTripView.frame = frame
            emptyTripView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.addSubview(emptyTripView)
            return
        } else  {
            presentTripView.frame = frame
            presentTripView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.addSubview(presentTripView)
        }
    }
    
    @IBAction func cancelToTripDetail(segue:UIStoryboardSegue) {}
    
    
    // Mark: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}