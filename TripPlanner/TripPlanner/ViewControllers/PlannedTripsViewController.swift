//
//  PlannedTripsViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

private var PlannedTripsCellIdentifier = "PlannedTripsCell"

class PlannedTripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var plannedTripsArrayDataSource: ArrayDataSource?
    
    var items = ["Berlin", "San Francisco", "Paris", "Takoradi", "London"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self

        setupTableView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

extension PlannedTripsViewController {
    
    func setupTableView() {
        
        plannedTripsArrayDataSource = ArrayDataSource(items: items, cellIdentifier: PlannedTripsCellIdentifier,
            tableViewConfigureCallback: {
                (cell, item) -> () in
            
            if let actualCell = cell as? PlannedTripsTVCell {
                if let actualItem = item as? String {
                    actualCell.configureCell(actualItem)
                }
            }
        })
        tableView.dataSource = plannedTripsArrayDataSource
        tableView.registerNib(PlannedTripsTVCell.nib(), forCellReuseIdentifier: PlannedTripsCellIdentifier)
    }
}

extension PlannedTripsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Push to next view controller
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
}