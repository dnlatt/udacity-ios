//
//  TouristOnMap+Extension.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 20/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

extension UIViewController {
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
