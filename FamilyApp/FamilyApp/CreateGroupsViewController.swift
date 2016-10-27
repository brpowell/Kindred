//
//  CreateGroupsViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class CreateGroupsViewController: InputViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func onCreateGroupButton(_ sender: AnyObject) {
        let userId = Database.user.uid
        let groupName = groupNameTextField.text!
        if (!groupName.isEmpty) {
            Database.db.createGroup(groupName: groupNameTextField.text!, userId: userId)
            statusLabel.text = "Group created!"
            statusLabel.isHidden = false
        } else {
            statusLabel.text = "Group not created"
            statusLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
