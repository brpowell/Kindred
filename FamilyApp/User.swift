//
//  User.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var birthday: String
    var photoUrl: URL?
    var photo: UIImage?
    
    static var activeUserImage: UIImage?
    
    init(authData: FIRUser, firstName: String, lastName: String, birthday: String) {
        self.uid = authData.uid
        self.email = authData.email!
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.photoUrl = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.firstName = (snapshotValue["firstName"] as? String)!
        self.lastName = (snapshotValue["lastName"] as? String)!
        self.birthday = (snapshotValue["birthday"] as? String)!
        self.email = (snapshotValue["email"] as? String)!
        self.uid = snapshot.key
        self.photoUrl = nil
    }
    
    init(snapshot: [String: NSDictionary]) {
        let key = snapshot.keys.first!
        let userDict = snapshot[key]!

        self.firstName = userDict.value(forKey: "firstName") as! String
        self.lastName = userDict.value(forKey: "lastName") as! String
        self.birthday = userDict.value(forKey: "birthday") as! String
        self.email = userDict.value(forKey: "email") as! String
        self.uid = key
        self.photoUrl = nil
    }
    
    func setPhotoUrl(photoUrl: URL) {
        self.photoUrl = photoUrl
    }
    
    func toAnyObject() -> [String: String] {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday
        ]
    }
    
    func addContact(user: User, relationship: String) {
        let newContactRef = Database.contactsRef.child(self.uid).child(user.uid)
        let selfContactRef = Database.contactsRef.child(user.uid).child(self.uid)
        
        let contactName = user.firstName + " " + user.lastName
        let selfName = self.firstName + " " + self.lastName
        
        var revRelationship: String?
        
        if relationship == "Mother" || relationship == "Father" {
            revRelationship = "Child"
        }
        else if relationship == "Grandmother" || relationship == "Grandfather" {
            revRelationship = "Grandchild"
        }
        else if relationship == "Aunt" || relationship == "Uncle" {
            revRelationship = "Nephew or Niece"
        }
        else if relationship == "Nephew" || relationship == "Niece" {
            revRelationship = "Uncle or Aunt"
        }
        else {
            revRelationship = relationship
        }
        
        let newContact = Contact(name: contactName, relationship: relationship, uid: user.uid)
        let selfContact = Contact(name: selfName, relationship: revRelationship!, uid: self.uid)
        
        newContactRef.setValue(newContact.toAnyObject())
        selfContactRef.setValue(selfContact.toAnyObject())
    }
}
