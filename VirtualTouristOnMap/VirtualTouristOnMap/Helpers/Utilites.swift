//
//  Utilites.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 18/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Utilites: UIViewController {
    
    static let photosPerPage = 21
    
    static func showMessage(title: String, message: String, view: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
}
