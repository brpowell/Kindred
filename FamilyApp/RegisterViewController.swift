//
//  RegisterViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: InputViewController {


    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var lastTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!

    var email = String()
    var password = String()
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Auth Listener
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                let user = User(authData: user!, firstName: self.firstTextField.text!, lastName: self.lastTextField.text!, birthday: self.birthdayTextField.text!)
                let userRef = self.ref.child(user.uid)
                userRef.setValue(user.toAnyObject())
                print("SET USER DATA")
                self.performSegue(withIdentifier: "registerHomeSegue", sender: nil)
            } else {
                // No user is signed in.
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func birthdayEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func onRegisterDone(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
            }
            else {
                print(error)
            }
        });
    }

}
