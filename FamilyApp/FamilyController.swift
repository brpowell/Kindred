//
//  FamilySearchView.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class FamilyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search() {
        let message = "Search for a family member by their email address"
        let userRef = FIRDatabase.database().reference(withPath: "users")
        let controller = UIAlertController(title: "Search Contact", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Email Address"
        })
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (paramAction:UIAlertAction!) in
            if let textField = controller.textFields {
                let theTextField = textField as [UITextField]
                let enteredText = theTextField[0].text

                userRef.queryOrdered(byChild: "email").queryEqual(toValue: enteredText).observeSingleEvent(of: .value, with: { snapshot in
                    
                    if let snapshotDict = snapshot.value as? [String: NSDictionary] {
                        let u = User(snapshot: snapshotDict)
                        
                        let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + u.uid)
                        
                        profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                            if error != nil {
                                print(error)
                            }
                            else {
                                u.photo = UIImage(data: data!)
                                OtherProfileViewController.user = u
                                self.performSegue(withIdentifier: "profileSegue", sender: self)
                            }
                        }
                    }
                    else {
                        let message = "We couldn't find that user, sorry!"
                        let notFoundController = UIAlertController(title: "User Not Found", message: message, preferredStyle: .alert)
                        notFoundController.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                        self.present(notFoundController, animated: true, completion: nil)
                    }
                    
                })
            }
            }
        ))
        
        present(controller, animated: true)

    }

}
