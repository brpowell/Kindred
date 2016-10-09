//
//  HomeViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Auth Listener
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                guard let user = user else { return }
                self.welcomeLabel.text = "Welcome " + user.email!
            } else {
                // No user is signed in.
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("signOutSegue", sender: sender)
    }


}
