//
//  AddWaypointViewController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/30/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import SVProgressHUD

protocol AddWaypointsDelegate: class {
    func didAddWaypoints(controller: AddWaypointViewController)
}

class AddWaypointViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchToMapConstraint: NSLayoutConstraint!

    var trip: Trip?
    var dataSource: ArrayDataSource?
    var placesClient: GMSPlacesClient?
    var places: [GMSPlace] = []
    var selectedPlace: WaypointModel?
    var autocompletePlace: [GMSAutocompletePrediction] = []
    var waypoints: [(String?, Location?)] = []
    
    weak var delegate: AddWaypointsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        setupTableView()
    }
    
    func prepare() {
        places = []
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func placeAutocomplete(place: String) {
        SVProgressHUD.show()
        prepare()
        
        let filter = GMSAutocompleteFilter()

        placesClient?.autocompleteQuery(place, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if let results = results as? [GMSAutocompletePrediction] {
                    self.autocompletePlace = results
                }
                
                self.setupTableView()
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
            
        })
    }
    
    /**
     Adds a pin to a MKMapView
     
     - parameter place: The Google Place
     */
    func addPinToMapView(place: GMSPlace) {
        
        prepare()
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegion(center: place.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    /**
     Fetches a place from a GMSAutocompletePrediction
     
     - parameter place: The autocomplete place which we later extract the placeID from
     */
    func fetchGooglePlace(place: GMSAutocompletePrediction) {
        placesClient?.lookUpPlaceID(place.placeID) {
            (place: GMSPlace?, error: NSError?) in
            
            guard let place = place else {return}
            let coordinate = place.coordinate
            let placeName = place.name
            self.selectedPlace = WaypointModel(latitude: coordinate.latitude, longitude: coordinate.longitude, name: placeName)
            self.addPinToMapView(place)
        }
    }
    
    func setupTableView() {
        dataSource = ArrayDataSource(items: autocompletePlace, cellIdentifier: "SearchResultsCell") {
            (cell, item) in
            
            if let placeCell = cell as? UITableViewCell {
                if let itemForCell = item as? GMSAutocompletePrediction {
                    placeCell.textLabel?.text = itemForCell.attributedFullText.string
                }
            }
        }
        tableView.dataSource = dataSource
    }
    
    
    func saveTrip() {
        var updatedTrip = TripModel(tripName: "")
        updatedTrip.tripId = trip?.tripId
        updatedTrip.tripName = trip?.tripName
        updatedTrip.tripUser = trip?.user
        updatedTrip.waypoints = [selectedPlace!] ?? []
        
        APIClient.sharedInstance.putTrip(updatedTrip)
    }
    
    // Adds a trip waypoint
    @IBAction func addWaypointPressed(sender: UIBarButtonItem) {
        
        saveTrip()
        delegate?.didAddWaypoints(self)
    }
}

// Mark: Search Bar Delegate

extension AddWaypointViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        APIClient.sharedInstance.fetchLikelyPlace(searchBar.text!) {
//            place in
//            
//        }
        
        placeAutocomplete(searchBar.text!)
        
        searchBar.resignFirstResponder()
        UIView.animateWithDuration(0.4) {
            UIViewAnimationCurve.EaseInOut
            self.searchToMapConstraint.constant = 0
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        UIView.animateWithDuration(0.4) {
            UIViewAnimationCurve.EaseInOut
            self.searchToMapConstraint.constant = 300
            self.view.layoutIfNeeded()
            self.view.setNeedsDisplay()
        }
    }
    
}

// Mark: MKMapView Delegate

extension AddWaypointViewController: MKMapViewDelegate {
//    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
//        var region: MKCoordinateRegion
//        region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 37, longitude: 102), 40, 30)
//        
//        mapView.setRegion(region, animated: true)
//    }
    // From https://gist.github.com/andrewgleave/915374 by Souf-R
    func fitMapViewToAnnotaionList(annotations: [MKPointAnnotation]) -> Void {
        let mapEdgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for index in 0..<annotations.count {
            let annotation = annotations[index]
            let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        
        mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinView:MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinTintColor = MKPinAnnotationView.greenPinColor()
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        
        return pinView
    }
}

// Mark: UITableview Delagate

extension AddWaypointViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = autocompletePlace[indexPath.row]
        fetchGooglePlace(item)
    }
}