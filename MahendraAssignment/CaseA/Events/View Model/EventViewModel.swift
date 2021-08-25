//
//  EventViewModel.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import Foundation
import UIKit
import CoreData

class EventViewModel {
    var totalEvents: Array<Events>?
    init() {
        
    }
    
    func getEvents() -> [Events]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
         let managedContext =  appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as? [Events]
            if result?.count ?? 0 > 0 {
               
                return result
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
            return nil
        }
    }
}
