//
//  SubmitStudentLocationViewController.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 2/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import MapKit

class SubmitStudentLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    var studentInformation: StudentInformation?
    
    // MARK: IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: System Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStudentLocation()
        // Do any additional setup after loading the view.
    }
    

    //MARK: Add Location
    
    private func setStudentLocation() {
        self.mapView.removeAnnotations(mapView.annotations)
        let lat = CLLocationDegrees(studentInformation?.latitude ?? 0.0)
        let long = CLLocationDegrees(studentInformation?.longitude ?? 0.0)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let first = studentInformation?.firstName ?? ""
        let last = studentInformation?.lastName ?? ""
        let mediaURL = studentInformation?.mediaURL ?? ""
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // MARK: Add Student Location
    
    @IBAction func finishTapped(_ sender: Any) {
        if let studentInformation = self.studentInformation {
            UdacityClient.addStudentLocation(information: studentInformation) { (success, error) in
                print("Status \(success)")
                print("Status \(error)")
                if success {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                    }
                }
            }
        }
    
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
