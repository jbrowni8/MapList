//
//  Controller.swift
//  MapList
//
//  Created by James Browning on 3/8/17.
//  Copyright © 2017 James Browning. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class Controller: UIViewController {
    
    var locationTypes : [String] = []
    var selectedType : String = ""
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    // Update the map once the user has made their selection.
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()
        
        selectedType = getSelectedType(selectedType: selectedType)
        
        // Add a marker to the map.
        
        for item in likelyPlaces {
            
            if item.types[0] == selectedType {
                let marker = GMSMarker(position: (item.coordinate))
                marker.title = item.name
                marker.snippet = item.formattedAddress
                marker.map = mapView
            }
        }
        
        listLikelyPlaces()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        listLikelyPlaces()
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    _ = String(likelihood.place.types[0])
                    //print("\(text)")
                    let place = likelihood.place
                    self.locationTypes.append(place.types[0])
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    // Prepare the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelect" {
            if let nextViewController = segue.destination as? Controller {
                nextViewController.likelyPlaces = likelyPlaces
                nextViewController.locationTypes = locationTypes
            }
        }
    }
}

// Delegates to handle events for the location manager.
extension Controller: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func getSelectedType(selectedType : String) -> String {
        
        var newSelectedType : String = ""
        
        if selectedType == "Street address" {
            newSelectedType = "street_address"
        } else if selectedType == "Point of interest" {
            newSelectedType = "point_of_interest"
        } else if selectedType == "Real estate agency" {
            newSelectedType = "real_estate_agency"
        } else if selectedType == "Pet store"{
            newSelectedType = "pet_store"
        } else if selectedType == "Furniture store" {
            newSelectedType = "furniture_store"
        } else if selectedType == "Clothing store" {
            newSelectedType = "clothing_store"
        } else if selectedType == "Lodging" {
            newSelectedType = "lodging"
        } else if selectedType == "Parking" {
            newSelectedType = "parking"
        } else if selectedType == "Night club" {
            newSelectedType = "night_club"
        } else if selectedType == "Department store" {
            newSelectedType = "department_store"
        } else if selectedType == "Store" {
            newSelectedType = "store"
        } else if selectedType == "Transit station" {
            newSelectedType = "transit_station"
        } else if selectedType == "Shoe store" {
            newSelectedType = "shoe_store"
        } else if selectedType == "Shopping mall" {
            newSelectedType = "shopping_mall"
        }
        
        return newSelectedType
    }
    
}
