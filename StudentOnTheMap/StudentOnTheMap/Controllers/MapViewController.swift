//
//  MapViewController.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // Mark Properties
    var studentsLocations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setStudentsPins()
        
    }
    
    // MARK: Get Students Locations Pins
    
    func setStudentsPins() {
        setLoading(true)
        UdacityClient.getAllStudentsLocations(completion: { (students, error) in
            
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.studentsLocations = students ?? []
            
            for studentLocation in self.studentsLocations {
                let lat = CLLocationDegrees(studentLocation.latitude)
                let long = CLLocationDegrees(studentLocation.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = studentLocation.firstName
                let last = studentLocation.lastName
                let mediaURL = studentLocation.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }

            DispatchQueue.main.async {
                 self.mapView.addAnnotations(self.annotations)
                
            }
        })
        setLoading(false)
    }
    
    // Mark Tab Bar Actions

    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.logOut {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addStudentLocationTapped(_ sender: Any) {
        performSegue(withIdentifier: "addStudentLocation", sender: sender)
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        setStudentsPins()
    }
    
    // MARK: Map view data source
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openWebLink(toOpen ?? "")
            }
        }
    }
    
    // MARK: Loading Status
    
    func setLoading(_ loadingStatus: Bool) {
        if loadingStatus {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
