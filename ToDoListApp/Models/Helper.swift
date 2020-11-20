//
//  HelperFunctions.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 11/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import UserNotifications

class Helper {
    
    
    
    // MARK: - Fix NavBar Background issue for iOS 13
    static func navBarIOS13() {
        if #available(iOS 13.0, *) {
            
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            coloredAppearance.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                   
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            
        }
        
    }
    
    
    
    // MARK: - Check User Theme Color
    static func themeCheck() {
        
        let defaults = UserDefaults.standard
        let blackColorTheme = defaults.bool(forKey: KeyUserDefaults.colorTheme)
        let settings = DefaultSettings.sharedInstance
        
        if blackColorTheme == true {
            settings.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.buttonBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            settings.buttonLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.labelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            settings.buttonText = "Dark Mode".localized()
        } else {
            settings.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            settings.buttonBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.buttonLabelColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            settings.labelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.buttonText = "Light Mode".localized()
        }
    }
    
    
    
    // MARK: - Request to use PUSH Notification
    static func authorizationPushNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        if success {
            print("USER PUSH NOTIFICATION SUCCESS")
        } else if let error = error {
            print("Error USER NOTIFICATION : \(error)")
        }
    }
    }
    
    // MARK: - Request to use Calendar
    static func authorizationCalendarEvent() {
        
    let eventStore = EKEventStore()
        
    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
        print("CALENDAR AUTHORIZED")
    case .denied:
        print("CALENDAR ACCESS DENIED")
    case .notDetermined:
        eventStore.requestAccess(to: .event, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    print("CALENDAR GRANTED")
                } else {
                    print("CALENDAR ACCESS DENIED")
                }
        })
    default:
        print("CALENDAR CASE DEFAULT")
    }
    }
    
    
    
    // MARK: - Fonts Check
    static func fontsCheck() {
        
        for family: String in UIFont.familyNames.sorted() {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    
    
    
    
}
