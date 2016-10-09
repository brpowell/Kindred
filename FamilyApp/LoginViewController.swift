//
//  ViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/8/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: InputViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Auth Listener
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegueWithIdentifier("loginHomeSegue", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        let email = emailTextField.text!
        let pass = passwordTextField.text!
        
        if email != "" && pass != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in

            })
        }
        else {
            // Alert popup invalid email or password
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registerSegue",
            let destination = segue.destinationViewController as? RegisterViewController {
            destination.email = emailTextField.text!
            destination.password = passwordTextField.text!
        }
    }

}

