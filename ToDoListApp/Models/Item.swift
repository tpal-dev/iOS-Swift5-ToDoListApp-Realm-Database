//
//  Item.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 03/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var row: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var dateReminder: String?
    @objc dynamic var eventID: String?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
