//
//  Habits+CoreDataProperties.swift
//  iHabit
//
//  Created by Na Wu on 2016-03-27.
//  Copyright © 2016 Na Wu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Habits {

    @NSManaged var date: NSDate?
    @NSManaged var habitname: String?
    @NSManaged var status: NSNumber?
    @NSManaged var continualdays: NSNumber?

}
