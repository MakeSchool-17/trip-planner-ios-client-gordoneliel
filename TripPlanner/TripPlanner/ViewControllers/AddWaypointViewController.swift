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

class AddWaypointViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchToMapConstraint: NSLayoutConstraint!

    
    var placesClient: GMSPlacesClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
    }
    
    func placeAutocomplete(place: String) {
        let filter = GMSAutocompleteFilter()

        filter.type = GMSPlacesAutocompleteTypeFilter.Region
        placesClient?.autocompleteQuery(place, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
//                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                    
                    self.placesClient?.lookUpPlaceID(result.placeID) {
                        (place: GMSPlace? , error: NSError?) in
                        print(place)
                    }
                }
            }
        })
    }
    
    func addPinToMapView() {
        let annotation = MKAnnotationView()
        
    }
}

extension AddWaypointViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        placeAutocomplete(searchBar.text!)
        
//        UIView.animateWithDuration(0.4) {
//            self.searchToMapConstraint.constant = 0
//            self.view.setNeedsDisplay()
//            self.view.layoutIfNeeded()
//        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        UIView.animateWithDuration(0.4) {
            self.searchToMapConstraint.constant = 300
            self.view.layoutIfNeeded()
            self.view.setNeedsDisplay()
        }
    }
    
}

extension AddWaypointViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        var region: MKCoordinateRegion
        region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 37, longitude: 102), 40, 30)
        
        mapView.setRegion(region, animated: true)
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