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
    
    @IBOutlet weak var tripNameField: UITextField!
    
    enum DataError : ErrorType {
        case EmptyText
        // add more later
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addTrip() throws {
        
        defer {tripAddDelegate?.tripAddFinished(self, trip: "")}
        
        guard let tripName = tripNameField.text else{
            throw DataError.EmptyText
        }
        
        tripAddDelegate?.tripAddFinished(self, trip: tripName)
    }
}


