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
    
    var ref: FIRDatabaseReference!
    let storageUrl = "gs://familyapp-e0bae.appspot.com"
    
    static let db = Database()
    static var user: User!
    
    
    static let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
    static let usersRef = FIRDatabase.database().reference(withPath: "users")
    static let postImagesRef = FIRStorage.storage().reference(withPath: "postImages")
    static let profileImagesRef = FIRStorage.storage().reference(withPath: "profileImages")
    
    static var profileImageCache = NSCache<NSString, UIImage>()
    
    private init() {
        getCurrentUser()
    }
    
    func getCurrentUser() {
        if let currentUser = FIRAuth.auth()?.currentUser {
            let uid = currentUser.uid
            let photoUrl = currentUser.photoURL!
            
            ref = FIRDatabase.database().reference(withPath: "users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                Database.user = User(snapshot: snapshot)
                Database.user.setPhotoUrl(photoUrl: photoUrl)
            })
        }
    }
    
    func getUser(uid: String) {
        var findUser: User?
        ref = FIRDatabase.database().reference(withPath: "users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            findUser = User(snapshot: snapshot)
            print(findUser?.firstName)
        })
    }
    
    func getContacts() {
        ref = FIRDatabase.database().reference(withPath: "contacts").child(Database.user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for person in snapshot.children {
                let snap = person as! FIRDataSnapshot
                let uid = snap.key
                print(uid)
            }
        })
    }
    
    func getGroupMembers(groupId: String) {
        ref = FIRDatabase.database().reference(withPath: "groupmembers").child(groupId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for person in snapshot.children {
                let snap = person as! FIRDataSnapshot
                let uid = snap.key
                print(uid)
            }
        })
    }
    
    func addMemberToGroup(groupId: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "groups")
        ref.child("\(groupId)/\("members")/\(userId)").setValue(true)
        
        ref = FIRDatabase.database().reference(withPath: "users")
        ref.child("\(userId)/\("groups")/\(groupId)").setValue(true)
    }
    
    func addContact(userId: String) {
        ref = FIRDatabase.database().reference(withPath: "contacts")
        let currentUserId = Database.user.uid
        ref.child("\(currentUserId)/\(userId)").setValue(true)
    }
    
    func createGroup(groupName: String, userId: String) {
        ref = FIRDatabase.database().reference(withPath: "groups")
        let key = ref.childByAutoId().key
        ref.child("\(key)").setValue(["name": groupName])
        
        //Add current user to the group he/she just created
        addMemberToGroup(groupId: key, userId: userId)
    }
    
    func deleteGroup(groupId: String) {
        //Delete group from all users
        //Delete group chat
        //Delete group
    }
    
}






