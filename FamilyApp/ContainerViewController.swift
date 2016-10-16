//
//  ContainerViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize drawer and set feed as default main view
        self.leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "Left")
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user == nil {
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
