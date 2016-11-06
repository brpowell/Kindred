//
//  ProfileInfoViewController.swift
//  FamilyApp
//
//  Created by Apurva Gorti on 10/31/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class ProfileInfoViewController: UIViewController {

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = OtherProfileViewController.user
        
        if let birthday = user?.birthday {
            birthdayLabel.text = birthday
        }
        
        if let email = user?.email {
            emailLabel.text = email
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
