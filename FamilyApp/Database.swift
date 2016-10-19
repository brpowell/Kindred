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
    var ref: FIRDatabaseReference!

    private init() {
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
    
    func createGroup(groupName: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "groups")
        let key = ref.childByAutoId().key
        ref.child("\(key)").setValue(["name": groupName])
        addMemberToGroup(groupId: key, userId: userId)
    }
    
    func addMemberToGroup(groupId: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "members")
        ref.child("\(groupId)/\(userId)").setValue(true)
    }
}
