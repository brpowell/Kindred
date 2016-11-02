//
//  FATextField.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/1/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

@IBDesignable public class FATextField: UITextField {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
