//
//  ProfileInfoViewController.swift
//  FamilyApp
//
//  Created by Apurva Gorti on 10/31/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class ProfileInfoViewController: UIViewController {

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = OtherProfileViewController.user

        let ref = FIRDatabase.database().reference(withPath: "settings").child(user!.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                let settings = Settings(snapshot: snapshot)
                let one = settings.settingOne!
                let two = settings.settingTwo!
                let three = settings.settingThree!
                
                if (two == false) {
                    self.birthdayLabel.isHidden = true
                }
                if (three == false) {
                    self.emailLabel.isHidden = true
                }
            }
            
            if let birthday = user?.birthday {
                self.birthdayLabel.text = birthday
            }
            if let email = user?.email {
                self.emailLabel.text = email
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
