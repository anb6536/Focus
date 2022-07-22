//
//  NoteModel.swift
//  Focus
//
//  Created by Aahish Balimane on 4/5/22.
//

import Foundation
import CoreData

class NoteItem: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var heading: String
    @NSManaged var body: String
    @NSManaged var dateModified: Date
}
