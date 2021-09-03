//
//  ViewControllerExtension.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 1/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

extension UIViewController{

    

    
    
    // MARK: Show alerts
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }

    // MARK: Open links in Safari
    
    func openWebLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}
