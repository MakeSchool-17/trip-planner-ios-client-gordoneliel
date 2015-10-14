//
//  PlannedTripsTest.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import XCTest

@testable import TripPlanner

class PlannedTripsTest: XCTestCase {
    private var PlannedTripsCellIdentifier = "PlannedTripsCell"
    var plannedTripsViewController: PlannedTripsViewController?
    var plannedTripsArrayDataSource: ArrayDataSource?
    let data = ["Berlin", "San Francisco", "Paris", "Takoradi", "London"]
    @IBOutlet weak var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        plannedTripsViewController = PlannedTripsViewController()
        plannedTripsViewController?.items = data
    }
    
    func setupTableView() {
        
        plannedTripsArrayDataSource = ArrayDataSource(items: data, cellIdentifier: PlannedTripsCellIdentifier,
            tableViewConfigureCallback: {
                (cell, item) -> () in
                
        })
    }

    
    func testPlannedTripsTableViewDataSource() {
        
        let data = ["Berlin", "San Francisco", "Paris", "Takoradi", "London"]
        
        
        XCTAssertTrue(plannedTripsViewController?.plannedTripsArrayDataSource?.items == data, "Items in data source comparison")
        
    }
}
