//
//  StringExtension.swift
//  ToDoList
//
//  Created by Tomasz Paluszkiewicz on 19/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
