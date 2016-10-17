//
//  LeftViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class LeftViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    
    // View controllers handled by the drawer
    var familyViewController: UIViewController!
    var groupsViewController: UIViewController!
    var feedViewController: UIViewController!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = FIRAuth.auth()?.currentUser
        userLabel.text = user?.displayName
        print("THE CURRENT USER: " + userLabel.text!)
        
        if let image = User.activeUserImage {
            profileImage.makeProfileFormat()
            profileImage.image = image
        }
        
        // Initialize Feed Controller
        let feedViewController = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
        self.feedViewController = UINavigationController(rootViewController: feedViewController!)
        
        // Initialize Family Controller
        // Each tabbed view has navigation controller embeded, as shown on storyboard
        self.familyViewController = self.storyboard?.instantiateViewController(withIdentifier: "Family")
        
        // Initialize Groups Controller
        let groupsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Groups")
        self.groupsViewController = UINavigationController(rootViewController: groupsViewController!)
        
        self.slideMenuController()?.changeMainViewController(self.feedViewController, close: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignOut(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func onFeedButton(_ sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.feedViewController, close: true)
    }
    
    @IBAction func onFamilyButton(_ sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.familyViewController, close: true)
    }
    
    @IBAction func onGroupsButton(_ sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.groupsViewController, close: true)
    }

}
