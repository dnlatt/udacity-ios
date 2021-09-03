//
//  ViewController.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 30/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IB Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLoggingIn(false)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    // MARK: Login Functions

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success: error:))
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "login", sender: nil)
        }
        else {
            showAlert(message: error?.localizedDescription ?? "", title: "Login Failed")
        }
    }
    
    // MARK: Sign Up
    
    @IBAction func signUpTapped(_ sender: Any) {
        let url = UdacityClient.Endpoints.signUp.url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: Set Login Status
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        
    }
}

