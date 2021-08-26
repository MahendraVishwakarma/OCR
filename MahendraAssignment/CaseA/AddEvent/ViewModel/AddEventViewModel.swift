//
//  AddEventViewModel.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import Foundation
import UIKit
import CoreData
import EventKit

class AddEventViewModel {
    var event:EventModel?
    var store: EKEventStore?
    var actionType:ActionTypes?
    
    init() {
        event = EventModel()
        store = EKEventStore()
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
        newevent.action = actionType == .event ? "Event" : "Reminder"
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func setReminderInSystem(){
        guard let calendar = self.store?.defaultCalendarForNewReminders() else { return }
        if let str = store {
            let reminder = EKReminder(eventStore: str)
            reminder.calendar = calendar
            reminder.title = event?.title
            reminder.notes = event?.eventDescription
            reminder.priority = 2
            
            if let dueDate = event?.eventDate {
                //reminder.completionDate = dueDate
                let calender = Calendar.current
                reminder.dueDateComponents = calender.dateComponents([.year, .month, .day, .hour,.minute,.second], from: dueDate)
                let alarm = EKAlarm(absoluteDate: dueDate)
                reminder.addAlarm(alarm)
                if let alarmTime = calender.date(byAdding: .minute, value: -2, to: dueDate) {
                    let alarm2 = EKAlarm(absoluteDate: alarmTime)
                    reminder.addAlarm(alarm2)
                }
                
            }
            do {
                try store?.save(reminder, commit: true)
            }catch(let error){
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setEvent() {
        if let str = store {
            let event = EKEvent(eventStore: str)
            event.title = self.event?.title

            event.notes = self.event?.eventDescription
            let calender = Calendar.current
            event.calendar = str.defaultCalendarForNewEvents
            
            
            if let dueDate = self.event?.eventDate {
                let alarm = EKAlarm(absoluteDate: dueDate)
                event.addAlarm(alarm)
                
                event.startDate = dueDate
                event.endDate = dueDate
                if let alarmTime = calender.date(byAdding: .minute, value: -2, to: dueDate) {
                    let alarm2 = EKAlarm(absoluteDate: alarmTime)
                    event.addAlarm(alarm2)
                }
            }
            do {
                try str.save(event, span: .thisEvent)
                print("events added with dates:")
            } catch let e as NSError {
                print(e.description)
                return
            }
            print("Saved Event")
        }
        
    }
    func askForPermission(grantedAction: @escaping () -> Void) {
        store?.requestAccess(to: .reminder) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
            
            if granted {
                if self.actionType == .event {
                    self.setEvent()
                }else {
                    self.setReminderInSystem()
                }
               
            }
        }
    }
}

protocol EventAction:AnyObject {
    func updateEvent(eventDate:Date)
}
