//
//  Event+CoreDataProperties.swift
//  todolist
//
//  Created by HaoKai Lee on 2022/3/31.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var title: String?

}

extension Event : Identifiable {

}
