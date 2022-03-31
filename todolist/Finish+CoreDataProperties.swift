//
//  Finish+CoreDataProperties.swift
//  todolist
//
//  Created by HaoKai Lee on 2022/3/31.
//
//

import Foundation
import CoreData


extension Finish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Finish> {
        return NSFetchRequest<Finish>(entityName: "Finish")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: String?
}

extension Finish : Identifiable {

}
