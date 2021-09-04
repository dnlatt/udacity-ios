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
    
    // MARK: Properties
    
    var textFields: [UITextField] {
        return [studentLocationTextField, studentURLTextField]
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields.forEach {
            $0.delegate = self
            $0.text = ""
        }
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
        setLoggingIn(false)
    }
    
    // MARK: Find Location
    
    private func findGeocodePosition(searchLocation: String) {
        
        setLoggingIn(true)
        
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
        
        // Build Student Info
    
        let studentInfoDict = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": studentURLTextField.text!,
            "mediaURL": studentURLTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]
        
        let studentInfo = StudentInformation(studentInfoDict)
        
        controller.studentInformation = studentInfo
        self.navigationController?.pushViewController(controller, animated: true)
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
    
    // MARK: Set Button State
    
    func setButtonState(_ buttonState: Bool) {
        findLocation.isEnabled = buttonState
    }
    
    func checkTextFieldsStatus()
    {
        if studentLocationTextField.text != "" && studentURLTextField.text != "" {
            setButtonState(true)
        }else if studentLocationTextField.text! == "" || studentURLTextField.text! == "" {
            setButtonState(false)
        }else {
            setButtonState(false)
        }
    }
}


extension AddStudentLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // last textfield, dismiss keyboard directly
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextFieldsStatus()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkTextFieldsStatus()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkTextFieldsStatus()
        return true
    }
}

// MAKK : Keyboard Show / Hide
extension AddStudentLocationViewController {
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:   UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if studentURLTextField.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
