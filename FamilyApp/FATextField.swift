//
//  FATextField.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/1/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

@IBDesignable
class FATextField: UIView, UITextFieldDelegate, UIPickerViewDelegate {
    
    let animationDeltaY: CGFloat = 5.0
    let animationDuration: TimeInterval = 0.25
    
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
    
    @IBInspectable var barColor: UIColor = UIColor(red:0.75, green:0.93, blue:0.38, alpha:1.0) {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var editingColor: UIColor = UIColor.cyan
    
    @IBInspectable var icon: UIImage = UIImage() {
        didSet {
            icon = icon.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            reloadView()
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            reloadView()
        }
    }
    
    @IBInspectable var type: String = "email" {
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
        self.iconView.tintColor = UIColor.white
        UIView.animate(withDuration: self.animationDuration) {
            self.iconView.center.y -= self.animationDeltaY
            self.barLine.backgroundColor = self.editingColor
        }
        
        if type == "date" {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            self.textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.textField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.iconView.tintColor = UIColor.black
        UIView.animate(withDuration: self.animationDuration) {
            self.iconView.center.y += self.animationDeltaY
            self.barLine.backgroundColor = self.barColor
        }
    }
    
    private func reloadView() {
        iconView.image = self.icon
        iconView.tintColor = UIColor.black
        barLine.backgroundColor = self.barColor
        textField.placeholder = self.placeholder
        textField.isSecureTextEntry = false
        textField.autocapitalizationType = self.capitalization ? .words : .none
        
        // Keyboard type
        switch(self.type) {
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
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        
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
