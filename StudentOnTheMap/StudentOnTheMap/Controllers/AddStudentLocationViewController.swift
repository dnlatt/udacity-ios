//
//  AddLocationViewController.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationViewController: UIViewController {
    
    //MARK: IB Outlets
    
    @IBOutlet weak var studentLocationTextField: UITextField!
    @IBOutlet weak var studentURLTextField: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        studentLocationTextField.text = ""
        studentURLTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: Cancel Button 
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Find Location
    
    
    @IBAction func findLocationTapped(_ sender: Any) {
        setLoggingIn(true)
        guard let url = URL(string: self.studentURLTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please include 'http://' or 'https://' in your link.", title: "Invalid URL")
            setLoggingIn(false)
            return
        }
        findGeocodePosition(searchLocation: studentLocationTextField.text ?? "" )
    }
    
    // MARK: Find Location
    
    private func findGeocodePosition(searchLocation: String) {
        
        
        CLGeocoder().geocodeAddressString(searchLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                     self.setNewLocation(location.coordinate)
                       
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                }
            }
        }
        
        setLoggingIn(false)

    }
    
    // MARK: Redirect to Submit Location
    
    private func setNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SubmitStudentLocationViewController") as! SubmitStudentLocationViewController
        let firstName = generateName()
        let lastName = generateName()
        
        let studentInfo = StudentInformation(firstName: firstName, lastName: lastName, longitude: coordinate.longitude, latitude: coordinate.latitude, mapString: studentURLTextField.text!, mediaURL: studentURLTextField.text!, uniqueKey: UdacityClient.Auth.key, objectId: "", createdAt: "", updatedAt: "")
        controller.studentInformation = studentInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Generate Random Name
    
    private func generateName() -> String {
        let array = ["Adam", "Alex", "Aaron", "Ben", "Carl", "Dan", "David", "Edward", "Fred", "Frank", "George", "Hal", "Hank", "Ike", "John", "Jack", "Joe", "Larry", "Monte", "Matthew", "Mark", "Nathan", "Otto", "Paul", "Peter", "Roger", "Roger", "Steve", "Thomas", "Tim", "Ty", "Victor", "Walter", "Anderson", "Ashwoon", "Aikin", "Bateman", "Bongard", "Bowers", "Boyd", "Cannon", "Cast", "Deitz", "Dewalt", "Ebner", "Frick", "Hancock", "Haworth", "Hesch", "Hoffman", "Kassing", "Knutson", "Lawless", "Lawicki", "Mccord", "McCormack", "Miller", "Myers", "Nugent", "Ortiz", "Orwig", "Ory", "Paiser", "Pak", "Pettigrew", "Quinn", "Quizoz", "Ramachandran", "Resnick", "Sagar", "Schickowski", "Schiebel", "Sellon", "Severson", "Shaffer", "Solberg", "Soloman", "Sonderling", "Soukup", "Soulis", "Stahl", "Sweeney", "Tandy", "Trebil", "Trusela", "Trussel", "Turco", "Uddin", "Uflan", "Ulrich", "Upson", "Vader", "Vail", "Valente", "Van Zandt", "Vanderpoel", "Ventotla", "Vogal", "Wagle", "Wagner", "Wakefield", "Weinstein", "Weiss", "Woo", "Yang", "Yates", "Yocum", "Zeaser", "Zeller", "Ziegler", "Bauer", "Baxster", "Casal", "Cataldi", "Caswell", "Celedon", "Chambers", "Chapman", "Christensen", "Darnell", "Davidson", "Davis", "DeLorenzo", "Dinkins", "Doran", "Dugelman", "Dugan", "Duffman", "Eastman", "Ferro", "Ferry", "Fletcher", "Fietzer", "Hylan", "Hydinger", "Illingsworth", "Ingram", "Irwin", "Jagtap", "Jenson", "Johnson", "Johnsen", "Jones", "Jurgenson", "Kalleg", "Kaskel", "Keller", "Leisinger", "LePage", "Lewis", "Linde", "Lulloff", "Maki", "Martin", "McGinnis", "Mills", "Moody", "Moore", "Napier", "Nelson", "Norquist", "Nuttle", "Olson", "Ostrander", "Reamer", "Reardon", "Reyes", "Rice", "Ripka", "Roberts", "Rogers", "Root", "Sandstrom", "Sawyer", "Schlicht", "Schmitt", "Schwager", "Schutz", "Schuster", "Tapia", "Thompson", "Tiernan", "Tisler"]
        let randomName = array.randomElement()!
        return randomName
    }
    
    // MARK: Set Login Status
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        studentLocationTextField.isEnabled = !loggingIn
        studentURLTextField.isEnabled = !loggingIn
        findLocation.isEnabled = !loggingIn
        
    }
}
