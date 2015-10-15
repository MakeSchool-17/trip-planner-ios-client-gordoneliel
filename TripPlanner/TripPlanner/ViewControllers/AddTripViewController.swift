//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/15/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

protocol AddTripDelegate: class {
    
    func tripAddFinished(controller: AddTripViewController, trip: AnyObject)

}

class AddTripViewController: UIViewController {

    weak var tripAddDelegate: AddTripDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


