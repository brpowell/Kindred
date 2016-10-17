//
//  SearchContactPopup.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/17/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let message = "Search for a family member by their email address"

class SearchContactPopup {
    
    let userRef = FIRDatabase.database().reference(withPath: "users")
    let controller = UIAlertController(title: "Search Contact", message: message, preferredStyle: .alert)
    
    init() {
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Email Address"
        })
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (paramAction:UIAlertAction!) in
            if let textField = self.controller.textFields {
                let theTextField = textField as [UITextField]
                let enteredText = theTextField[0].text
                // TODO: Query Firebase for user with email address. if not found display alert
                let derp = self.userRef.queryOrdered(byChild: "email").queryEqual(toValue: enteredText).observe(.childAdded, with: { snapshot in
                    print(snapshot)
                })
            }
            }
        ))
    }
    
}




