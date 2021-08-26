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
    var eventObj:Events?
    var store: EKEventStore?
    var actionType:ActionTypes?
    weak var delegate: EventAction?
    
    init() {
        event = EventModel()
        store = EKEventStore()
        askForPermission {}
    }
    func doAction(action:String) {
        if(actionType == .event) {
            self.setEvent()
        }else if(actionType == .reminder) {
            self.setReminderInSystem()
        }else if(action == "deleteEvent") {
            self.deleteAction()
        }else if(action == "deleteReminder") {
           // self.deleteAction()
        }else if(action == "update") {
            if let evnt = eventObj {
                self.updateEvents(eventData: evnt)
            }
            
        }
    }
    private func addEventInLocalStorage(eventID: String){
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
        newevent.actionID = eventID
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    private func deleteEventfromLocalStorage(eventObj:NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
       managedContext.delete(eventObj)
        
    }
    private func goBack(){
        delegate?.updateEvent(eventName: "goback")
    }
    private func deleteAction(){
        if let eventDelete = self.store?.event(withIdentifier: event?.eventID ?? "") {
            try? self.store?.remove(eventDelete, span: .thisEvent, commit: true)
            
        }
        if let obj = eventObj {
            self.deleteEventfromLocalStorage(eventObj: obj)
        }
        
        self.goBack()
    }
    
    private func updateEvents(eventData:Events) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            eventData.event_description = event?.eventDescription
            eventData.title = event?.title
            eventData.date = event?.date
            try managedContext.save()
            self.goBack()
        }catch{
            
        }
    }
    private func setReminderInSystem(){
        store?.requestAccess(to: .reminder) {[weak self] (granted, error) in
            if let error = error {
                print(error)
                return
            }
            if(granted) {
                guard let calendar = self?.store?.defaultCalendarForNewReminders() else { return }
                if let str = self?.store {
                    let reminder = EKReminder(eventStore: str)
                    reminder.calendar = calendar
                    reminder.title = self?.event?.title
                    reminder.notes = self?.event?.eventDescription
                    reminder.priority = 2
                    
                    if let dueDate = self?.event?.eventDate {
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
                        try self?.store?.save(reminder, commit: true)
                        let reminderID = reminder.calendarItemIdentifier
                        DispatchQueue.main.async {
                            self?.addEventInLocalStorage(eventID: reminderID)
                            self?.goBack()
                        }
                        
                    }catch(let error){
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        
    }
    
    private func setEvent() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if(status == .authorized) {
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
                    let eventID = event.eventIdentifier ?? "0"
                    DispatchQueue.main.async {
                        self.addEventInLocalStorage(eventID: eventID)
                        self.goBack()
                    }
                    
                    print("events added with dates:")
                } catch let e as NSError {
                    print(e.description)
                    return
                }
                print("Saved Event")
            }
        }else {
            askForPermission {}
        }
        
        
    }
    private func askForPermission(grantedAction: @escaping () -> Void) {
        
        store?.requestAccess(to: .reminder) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
        }
        store?.requestAccess(to: .event) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
}

protocol EventAction:AnyObject {
    func updateEvent(eventName:String)
}
