//
//  ArrayDataSource.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import UIKit

typealias TableViewCellConfigureCallback = (cell: UITableViewCell, item: AnyObject?) -> ()

class ArrayDataSource: NSObject {
    var items = []
    var cellIdentifier: String?
    var tableViewConfigureCallback: TableViewCellConfigureCallback?

    init(items: [AnyObject], cellIdentifier: String, tableViewConfigureCallback: TableViewCellConfigureCallback){
        
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.tableViewConfigureCallback = tableViewConfigureCallback
        super.init()
    }

    /**
    The item at the specified index path in a tableview, or similar collection
    
    - parameter indexPath: The indexpath to fetch the item
    
    - returns: The item at the specified indexpath
    */
    func itemAtIndex(indexPath: NSIndexPath) -> AnyObject {
        return items[indexPath.row]
    }
}

// MARK : UITableViewDataSource
extension ArrayDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
        
        let item: AnyObject = itemAtIndex(indexPath)
        
        if let callback = tableViewConfigureCallback {
            callback(cell: cell, item: item)
        }
        
        return cell
    }
}