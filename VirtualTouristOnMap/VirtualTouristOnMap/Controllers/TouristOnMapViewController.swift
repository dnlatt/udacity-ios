//
//  ViewController.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 16/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TouristOnMapViewController: UIViewController {
    
    // MARK: IB Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    // MARK: Properties
    
    var pins: [Pin] = []
    var mapPinAnnotation: MKPointAnnotation? = nil
    var pinFetchedResults: NSFetchedResultsController<Pin>!
    var selectedPinAnnotation: MKPointAnnotation!
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPinFetchResults()
        displayPinsOnMap()
        navigationTitle.title = "Virtual Tourist On Map"
    }
    
    // Add Pin to the Map
  
    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        
        // Get Coordinates
        let currentLocation = sender.location(in: mapView)
        let currentLocationCoord = mapView.convert(currentLocation, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            
            // Get Pin Location and Add to map
            mapPinAnnotation = MKPointAnnotation()
            mapPinAnnotation!.coordinate = currentLocationCoord
            mapView.addAnnotation(mapPinAnnotation!)
            
            // Save Pin to Core Data
            let pin = Pin(context: DataController.shared.viewContext)
            pin.latitude = currentLocationCoord.latitude
            pin.longitude = currentLocationCoord.longitude
            
            do {
                try DataController.shared.viewContext.save()
                
            } catch {
                Utilites.showMessage(title: "Error", message: "Error while trying to save the Location", view: self)
            }
            
            pins.append(pin)
            
        }
    }
    
    // MARK: Navigate to Photo Album
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhotoAlbum" {
            if let viewController = segue.destination as? PhotoAlbumViewController {
                var selectedPin: Pin?
                
                for pin in pins {
                    let latitudeMatch = selectedPinAnnotation!.coordinate.latitude == pin.latitude
                    let longitudeMatch = selectedPinAnnotation!.coordinate.longitude == pin.longitude

                    if latitudeMatch && longitudeMatch {
                        selectedPin = pin
                        break
                    }
                }
                viewController.selectedPin = selectedPin
            }
        }
    }
}

// MARK: Fetched Results

extension TouristOnMapViewController: NSFetchedResultsControllerDelegate {
    func setupPinFetchResults() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "pinID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        pinFetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        pinFetchedResults.delegate = self
        
        do {
            try pinFetchedResults.performFetch()
        } catch {
            Utilites.showMessage(title: "Error", message: error.localizedDescription , view: self)
            
        }
    }
    
    func displayPinsOnMap() {
        for pin in pinFetchedResults.fetchedObjects ?? [] {
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            pins.append(pin)
            mapView.addAnnotation(pinAnnotation)
        }
    }
}

// MARK: - MKMapViewDelegate

extension TouristOnMapViewController : MKMapViewDelegate {
            
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = false
                pinView!.pinTintColor = .blue
                pinView!.animatesDrop = true
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
       
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            selectedPinAnnotation = view.annotation as? MKPointAnnotation
            performSegue(withIdentifier: "goToPhotoAlbum", sender: self)
            self.mapView.deselectAnnotation(selectedPinAnnotation!, animated: true)
            
        }
    
    

}
