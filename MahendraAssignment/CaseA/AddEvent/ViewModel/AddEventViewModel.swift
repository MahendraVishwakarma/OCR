//
//  AddEventViewModel.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import Foundation
import UIKit
import CoreData


class AddEventViewModel {
    var event:EventModel?
    
    init() {
        event = EventModel()
    }
    
    func addEventInLocalStorage(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //let newevent = NSEntityDescription.entity(forEntityName: "Events", in: managedContext)
        let newevent = Events(context: managedContext)
        newevent.title = event?.title ?? ""
        newevent.event_description = event?.eventDescription ?? ""
        newevent.date = event?.date ?? ""
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func setReminderInSystem(){
        
    }
}

protocol EventAction:AnyObject {
    func updateEvent(eventDate:Date)
}
