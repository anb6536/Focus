//
//  ToDoModel.swift
//  Focus
//
//  Created by Aahish Balimane on 4/5/22.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
}

class ToDoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var content: String
    @NSManaged var priorityNum: Int32
    @NSManaged var isComplete: Bool
    @NSManaged var dateRemind: Date?
    @NSManaged var dateDue: Date?
}

extension ToDoItem: Identifiable {
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}
