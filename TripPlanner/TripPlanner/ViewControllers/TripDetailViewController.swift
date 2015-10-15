//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trip: String?
    var tripDetailArrayDataSource: ArrayDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        if trip == nil {
            trip = "Berlin"
        }
//        setupTableView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension TripDetailViewController {
    func setupTableView() {
        
        tripDetailArrayDataSource = ArrayDataSource(items: [trip!], cellIdentifier: PlannedTripsCellIdentifier,
            tableViewConfigureCallback: {
                (cell, item) -> () in
                
                if let actualCell = cell as? PlannedTripsTVCell {
                    if let actualItem = item as? String {
                        actualCell.configureCell(actualItem)
                    }
                }
        })
        tableView.dataSource = tripDetailArrayDataSource
        tableView.registerNib(PlannedTripsTVCell.nib(), forCellReuseIdentifier: PlannedTripsCellIdentifier)
    }
}

extension TripDetailViewController: UITableViewDelegate {
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = PlannedTripsTVCell()
//        cell.configureCell(trip!)
//        return cell.contentView
//    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
}