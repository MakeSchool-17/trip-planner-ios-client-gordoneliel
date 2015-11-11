//
//  PresentTripView.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 11/3/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class PresentTripView: UIView {

    var trip: Trip?
    var dataSource: ArrayDataSource?
    
    @IBOutlet weak var tableView: UITableView!

    func setupTableView() {
        dataSource = ArrayDataSource(items:trip!.waypoints!.allObjects, cellIdentifier: "waypointsCell") {
            (cell, item) in
            
            if let placeCell = cell as? UITableViewCell {
                if let itemForCell = item as? Waypoint {
                    placeCell.textLabel?.text = itemForCell.name
                    placeCell.detailTextLabel?.text = "\(itemForCell.longitude!.stringValue), \(itemForCell.latitude!.stringValue)"
                }
            }
        }
        tableView.dataSource = dataSource
    }
}

extension PresentTripView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
}