//
//  DataController.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 18/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
        
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    static let shared = DataController(modelName: "VirtualTouristOnMap")
}
