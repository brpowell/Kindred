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
    
    static var listener: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                print(user?.email)
                self.performSegue(withIdentifier: "loginHomeSegue", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let email = emailTextField.text!
        let pass = passwordTextField.text!
        
        if email != "" && pass != "" {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                User.activeUser = user?.email
            })
        }
        else {
            // Alert invalid email or password
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue",
            let destination = segue.destination as? RegisterViewController {
            destination.email = emailTextField.text!
            destination.password = passwordTextField.text!
        }
    }

}

