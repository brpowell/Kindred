//
//  LeftViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class LeftViewController: UIViewController, SlideMenuControllerDelegate {

    @IBOutlet weak var userLabel: UILabel!
    
    // View controllers handled by the drawer
    var familyViewController: UIViewController!
    var groupsViewController: UIViewController!
    var feedViewController: UIViewController!
    var profileViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var feedButton: DrawerButton!
    @IBOutlet weak var familyButton: DrawerButton!
    @IBOutlet weak var groupsButton: DrawerButton!
    @IBOutlet weak var signOutButton: DrawerButton!
    @IBOutlet weak var settingsButton: DrawerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = FIRAuth.auth()?.currentUser
        userLabel.text = user?.displayName
        
        if let image = User.activeUserImage {
            profileImage.makeProfileFormat()
            profileImage.image = image
        }
        
        self.slideMenuController()?.delegate = self
        
        
        // Enable profile picture tapping
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LeftViewController.profileTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Initialize Feed Controller
        self.feedViewController = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
        
        // Initialize Family Controller
        // Each tabbed view has navigation controller embeded, as shown on storyboard
        self.familyViewController = self.storyboard?.instantiateViewController(withIdentifier: "Family")
        
        // Initialize Groups Controller
        self.groupsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Groups")
        
        // Intialize Profile Controller
        //TODO, also create new func
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile")
        self.profileViewController = UINavigationController(rootViewController: profileViewController!)
        
        // Intialize Settings Controller
        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Settings")
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController!)
        
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
    
    @IBAction func onSettingsButton(_ sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
    }
    
    func profileTapped() {
        self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
    }
    
//    func leftWillOpen() {
//        feedButton.center.x = self.view.center.x - self.view.bounds.width
//        familyButton.center.x = self.view.center.x - self.view.bounds.width
//        groupsButton.center.x = self.view.center.x - self.view.bounds.width
//        signOutButton.center.x = self.view.center.x - self.view.bounds.width
//    }
//    
//    func leftDidOpen() {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.feedButton.center.x += self.view.bounds.width - 28
//        })
//        UIView.animate(withDuration: 0.1, delay: 0.1 ,animations: {
//            self.familyButton.center.x += self.view.bounds.width - 28
//        })
//        UIView.animate(withDuration: 0.1, delay: 0.2 ,animations: {
//            self.groupsButton.center.x += self.view.bounds.width - 28
//        })
//        UIView.animate(withDuration: 0.1, delay: 0.3 ,animations: {
//            self.signOutButton.center.x += self.view.bounds.width - 28
//        })
//    }

}
