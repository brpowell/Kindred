//
//  PostViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/12/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    
    let postsRef = FIRDatabase.database().reference(withPath:
    "posts")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostButton(_ sender: AnyObject) {
        if let postBody = postTextView.text {
            let time = FIRServerValue.timestamp()
            let user = FIRAuth.auth()?.currentUser
            let key = postsRef.childByAutoId().key
            //            let postInfo = ["uid": user?.uid, "author": user?.displayName, "body": postBody, "timestamp": time]
            let data = [
                "uid": (user?.uid)!,
                "author": (user?.displayName)!,
                "body": postBody,
                "timestamp": time] as [String : Any]
            postsRef.child("\(key)").setValue(data)
            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        }
    }
    

}
