//
//  Todotask+CoreDataProperties.swift
//  Todotask
//
//  Created by Tools Team India on 20/11/16.
//  Copyright © 2016 Schneider-Electric. All rights reserved.
//

import Foundation
import CoreData


extension Todotask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todotask> {
        return NSFetchRequest<Todotask>(entityName: "Todotask");
    }

    @NSManaged public var createDate: NSDate?
    @NSManaged public var notifyDate: NSDate?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskSubject: String?

}
