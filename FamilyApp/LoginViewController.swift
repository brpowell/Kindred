//
//  ViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/8/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: InputViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    
    
    static var listener: Bool = true

    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginViewController.listener = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        
        // Listen for auth state change. listener flag to prevent double fire
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil && LoginViewController.listener{
                LoginViewController.listener = false
                self.startAnimating()
                let uid = FIRAuth.auth()?.currentUser?.uid
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + uid!)

                profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        User.activeUserImage = UIImage(data: data!)
                        Database.usersRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                            Database.user = User(snapshot: snapshot)
                            self.performSegue(withIdentifier: "loginHomeSegue", sender: nil)
                        })
                        
                    }
                }
            }
            else {
                self.stopAnimating()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        self.startAnimating()
        let email = emailTextField.text!
        let pass = passwordTextField.text!
        
        if email != "" && pass != "" {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if let error = error {
                    print(error)
                    self.stopAnimating()
                }
            })
        }
        else {
            // TODO: Alert email or password blank
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

