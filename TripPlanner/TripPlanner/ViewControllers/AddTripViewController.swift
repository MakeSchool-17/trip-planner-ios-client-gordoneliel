//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/15/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol AddTripDelegate: class {
    
    func tripAddFinished(controller: AddTripViewController, trip: AnyObject)

}

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var tripNameField: UITextField!
    
    enum DataError : String, ErrorType {
        case EmptyText
        // add more later
        var description: String {
            switch self{
                case .EmptyText: return "Trip name cannot be empty"
            }
        }
    }
    
    weak var tripAddDelegate: AddTripDelegate?
    var plannedTripsArrayDataSource: ArrayDataSource?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTripPressed(sender: UIBarButtonItem) {
        do{
            try addTrip()
        }catch let error as DataError {
            SVProgressHUD.showErrorWithStatus(error.description, maskType: .Black)
        }catch {
            
        }
    }
    /**
    Adds a trip and sends to delegate
    
    - throws: A DataError if text is empty
    */
    func addTrip() throws {
        
        guard !tripNameField.text!.isEmpty, let tripName = tripNameField.text else {
            throw DataError.EmptyText
        }
        saveTrip(tripName)
        
        tripAddDelegate?.tripAddFinished(self, trip: tripName)
    }
    
    func saveTrip(tripName: String) {
        let user = User()
        user.id = "23343"
        user.username = "eliel"
        APIClient.sharedInstance.postTrip(tripName, timeOfTrip: NSDate(), user: user.id!)
//        let trip = Trip()
//        trip.tripName = tripNameField.text
        
    }
    
}


