//
//  ProfileViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/17/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = Database.db.user.firstName + " " + Database.db.user.lastName
        birthday.text = Database.db.user.birthday
        email.text = Database.db.user.email
        
        if let image = User.activeUserImage {
            picture.makeProfileFormat()
            picture.image = image
        }
        
        
        Database.db.getContacts()
        Database.db.getGroupMembers(groupId: "-KUYam-BTTbSKf4NwVd-")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}
