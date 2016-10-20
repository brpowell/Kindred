//
//  OtherProfileViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    static var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = OtherProfileViewController.user
        
        if let firstName = user?.firstName {
            if let lastName = user?.lastName {
                nameLabel.text = firstName + " " + lastName
            }
        }
        
        if let birthday = user?.birthday {
            birthdayLabel.text = birthday
        }
        
        if let email = user?.email {
            emailLabel.text = email
        }
        
        if let image = user?.photo {
            userProfileImage.makeProfileFormat()
            userProfileImage.image = image
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func onMenuButton(_ sender: AnyObject) {
//        self.slideMenuController()?.openLeft()
//    }
}
