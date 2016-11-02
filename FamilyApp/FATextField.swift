//
//  FATextField.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/1/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

@IBDesignable
class FATextField: UIView, UITextFieldDelegate {
    
    var textField = UITextField()
    var iconView = UIImageView()
    var barLine = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 2))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
        textField.delegate = self
    }
    
//    @IBInspectable var iconColor: UIColor = UIColor.black {
//        didSet {
//            reloadView()
//        }
//    }
    
    @IBInspectable var barColor: UIColor = UIColor(red:0.75, green:0.93, blue:0.38, alpha:1.0) {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var editingColor: UIColor = UIColor.cyan
    
    @IBInspectable var icon: UIImage = UIImage() {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var keyboardType: String = "email" {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var capitalization: Bool = true {
        didSet {
            reloadView()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.barLine.backgroundColor = self.editingColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.barLine.backgroundColor = self.barColor
        }
    }
    
    private func reloadView() {
        iconView.image = self.icon
        barLine.backgroundColor = self.barColor
        textField.placeholder = self.placeholder
        textField.isSecureTextEntry = false
        
        textField.autocapitalizationType = self.capitalization ? .words : .none
        
        switch(self.keyboardType) {
            case "email":
                textField.keyboardType = .emailAddress
            case "password":
                textField.keyboardType = .default
                textField.isSecureTextEntry = true
            case "number":
                textField.keyboardType = .numberPad
            default:
                textField.keyboardType = .default
        }
        
        self.backgroundColor = UIColor.clear
        self.frame.size.height = 32
    }
    
    private func setupView() {
        self.frame.size.height = 32
        iconView.image = self.icon
        
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.white
        textField.placeholder = self.placeholder
        textField.tintColor = barColor
        
        barLine.backgroundColor = self.barColor
        
        addSubview(iconView)
        addSubview(textField)
        addSubview(barLine)
        
        addConstraintsWithFormat(format: "H:|[v0(32)]-12-[v1]|", views: iconView, textField)
        addConstraintsWithFormat(format: "H:|[v0(32)]-12-[v1]|", views: iconView, barLine)
        
        addConstraintsWithFormat(format: "V:|[v0(30)]-2-[v1(2)]|", views: textField, barLine)
        addConstraintsWithFormat(format: "V:|[v0(32)]", views: iconView)
    }
    
    
}
