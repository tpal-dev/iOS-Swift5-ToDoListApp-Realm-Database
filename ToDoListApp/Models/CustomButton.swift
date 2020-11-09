//
//  Button.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 09/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
