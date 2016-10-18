//
//  Database.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/17/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    static let db = Database()
    var user: User!

    private init() {
        var ref: FIRDatabaseReference!
        if let currentUser = FIRAuth.auth()?.currentUser {
            let uid = currentUser.uid
            let photoUrl = currentUser.photoURL!
            
            ref = FIRDatabase.database().reference(withPath: "users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                self.user = User(snapshot: snapshot)
                self.user.setPhotoUrl(photoUrl: photoUrl)
            })
        }
    }
    
    
//    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//    self.user = User(snapshot: snapshot)
//    print(user.uid)
//    
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        self.firstName = snapshotValue["firstName"] as? String
//        self.lastName = snapshotValue["lastName"] as? String
//        self.birthday = snapshotValue["birthday"] as? String
//    })
    
    
//    THIS WORKS EVERY CHILD
//    let postsRef = FIRDatabase.database().reference(withPath: "users")
//    postsRef.observe(.value, with: { snapshot in
//        for post in snapshot.children {
//            let snap = post as! FIRDataSnapshot
//            let snapshotValue = snap.value as! [String: AnyObject]
//
//            let stuff = snapshotValue["birthday"] as? String
//            print(stuff)
//        }
//    })
}
