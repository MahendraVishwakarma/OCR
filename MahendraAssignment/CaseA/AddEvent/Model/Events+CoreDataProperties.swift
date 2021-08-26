//
//  Events+CoreDataProperties.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var title: String?
    @NSManaged public var event_description: String?
    @NSManaged public var date: String?
    @NSManaged public var action: String?

}

extension Events : Identifiable {

}
