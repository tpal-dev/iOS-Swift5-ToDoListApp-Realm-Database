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
    static let helveticNeueLight = "HelveticaNeue-Light"
    
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
    static let tutorialVC = "TutorialViewController"
}

struct SegueIdentifier {
    static let goToItems = "goToItems"
}

struct ImageName {
    static let options = "options.png"
    static let chekmark = "checkmark.png"
    static let addCategory = "addCategory.png"
    static let addEvent = "addEvent.png"
    static let addNewItem = "addNewItem.png"
    static let changeColor = "changeColor.png"
    static let editItems = "editItems.png"
    static let itemCheck = "itemCheck.png"
    static let moveItem = "moveItem.png"
    static let optionSet = "optionSet.png"
    static let swipeDelete = "swipeDelete.png"
    
}

struct ViewName {
    static let slideTutorial = "SlideTutorial"
    static let slide = "Slide"
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
