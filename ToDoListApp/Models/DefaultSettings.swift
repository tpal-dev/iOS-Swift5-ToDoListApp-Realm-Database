//
//  Settings.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 11/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import Foundation
import UIKit

class DefaultSettings {
    
    static let sharedInstance = DefaultSettings()
    
    var backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var labelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var buttonLabelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var buttonBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var buttonText = ""
    
}
