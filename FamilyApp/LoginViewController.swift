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
    
    static var listener: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginViewController.listener = true
        
        // Listen for auth state change. listener flag to prevent double fire
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil && LoginViewController.listener{
                LoginViewController.listener = false
                let uid = FIRAuth.auth()?.currentUser?.uid
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + uid!)

                profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        User.activeUserImage = UIImage(data: data!)
                        self.performSegue(withIdentifier: "loginHomeSegue", sender: nil)
                    }
                }
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
                if let error = error {
                    print(error)
                }
            })
        }
        else {
            // TODO: Alert invalid email or password
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue",
            let destination = segue.destination as? RegisterViewController {
            destination.email = emailTextField.text!
            destination.password = passwordTextField.text!
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}

}

