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
    var plannedTripsArrayDataSource: ArrayDataSource?
    let data = ["Berlin", "San Francisco", "Paris", "Takoradi", "London"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func setUp() {
        super.setUp()

        setupTableView()
    }
    
    func setupTableView() {
        
        plannedTripsArrayDataSource = ArrayDataSource(items: data, cellIdentifier: PlannedTripsCellIdentifier,
            tableViewConfigureCallback: {
                (cell, item) -> () in
                
        })
    }

    /**
    Tests the DataSource of the CollectionView / TableView
    */
    func testPlannedTripsTableViewDataSource() {
        XCTAssertTrue(plannedTripsArrayDataSource?.items == data, "Items in data source comparison")
        
    }
}
