//
//  Constants.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 09/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import Foundation


struct Fonts {
    static let helveticNeueBold = "HelveticaNeue-Bold"
    static let helveticNeueMedium = "HelveticaNeue-Medium"
}

struct KeyUserDefaults {
    static let firstLaunch = "FirstLaunch"
    static let colorTheme = "DarkMode"
    static let firstAlarmDelay = "FirstAlarmDelay"
    static let secondAlarmDelay = "SecondAlarmDelay"
}

struct IdentifierVC {
    static let beginVC = "BeginViewController"
    static let categoryVC = "CategoryViewController"
    static let itemVC = "ItemViewController"
    static let optionsVC = "OptionsViewController"
}

struct SegueIdentifier {
    static let goToItems = "goToItems"
}

struct ImageName {
    static let options = "options.png"
    static let chekmark = "checkmark.png"
    
}

struct AnimationName {
    static let checklist = "checklist"
}

struct CellName {
    static let toDoItemCell = "ToDoItemCell"
}

struct KeyPath {
    static let dateCreated = "dateCreated"
}
