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
    
    // MARK: Properties
    
    var textFields: [UITextField] {
        return [emailTextField, passwordTextField]
    }
    
    // MARK: Life Cycle

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLoggingIn(false)
        setButtonState(false)
        
        textFields.forEach {
            $0.delegate = self
            $0.text = ""
        }
    }
    
    
    // MARK: Login Functions

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success: error:))
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        setLoggingIn(false)
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email!.isEmpty) || (password!.isEmpty) {
            
            showAlert(message: "Email and Password cannot be empty", title: "Error")
            
        } else {
            if error != nil {
                
                showAlert(message: "Failed Request!", title: "Error")
                
            }
            if !success {
                
                showAlert(message: "Invalid Credentials", title: "Login Failed")
                
            } else {
                
                performSegue(withIdentifier: "login", sender: nil)
                
            }
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
    
    func setButtonState(_ buttonState: Bool) {
        loginButton.isEnabled = buttonState
    }
    
    func checkTextFieldsStatus()
    {
        if emailTextField.text != "" && passwordTextField.text != "" {
            setButtonState(true)
        }else if emailTextField.text! == "" || passwordTextField.text! == "" {
            setButtonState(false)
        }else {
            setButtonState(false)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
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

