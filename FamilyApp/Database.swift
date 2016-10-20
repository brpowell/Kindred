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
        findCurrentUser()
    }
    
    func findCurrentUser() {
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
    
    func findMember(uid: String) {
        var findUser: User?
        ref = FIRDatabase.database().reference(withPath: "users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            findUser = User(snapshot: snapshot)
            print(findUser?.firstName)
        })
    }
    
    func createGroup(groupName: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "groups")
        let key = ref.childByAutoId().key
        ref.child("\(key)").setValue(["name": groupName])
        
        //Add current user to the group he/she just created
        addMemberToGroup(groupId: key, userId: userId)
    }
    
    func addMemberToGroup(groupId: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "groupmembers")
        ref.child("\(groupId)/\(userId)").setValue(true)
    }
    
    func addContact(userId: String) {
        ref = FIRDatabase.database().reference(withPath: "contacts")
        let currentUserId = user.uid
        ref.child("\(currentUserId)/\(userId)").setValue(true)
    }
    
    func getContacts() {
        ref = FIRDatabase.database().reference(withPath: "contacts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for person in snapshot.children {
                
                let snap = person as! FIRDataSnapshot
                let val = snap.value

                print(snap)
                print(val)
                print()
            }
        })
    }

}






