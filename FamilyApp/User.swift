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
    var gender: String
    var posts: [String: Post]?
    
    static var activeUserImage: UIImage?
    
    init() {
        firstName = ""
        lastName = ""
        email = ""
        birthday = ""
        gender = ""
        uid = ""
    }
    
    init(authData: FIRUser, firstName: String, lastName: String, birthday: String, gender: String) {
        self.uid = authData.uid
        self.email = authData.email!
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.photoUrl = nil
        self.gender = gender
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.firstName = (snapshotValue["firstName"] as? String)!
        self.lastName = (snapshotValue["lastName"] as? String)!
        self.birthday = (snapshotValue["birthday"] as? String)!
        self.email = (snapshotValue["email"] as? String)!
        self.uid = snapshot.key
        self.photoUrl = nil
        self.gender = (snapshotValue["gender"] as? String)!
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
        if (userDict.value(forKey: "gender") == nil) {
            self.gender = "Other"
        }
        else {
            self.gender = userDict.value(forKey: "gender") as! String
        }
        
    }
    
    func setPhotoUrl(photoUrl: URL) {
        self.photoUrl = photoUrl
    }
    
    func toAnyObject() -> [String: String] {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday,
            "gender": gender
        ]
    }
    
    func hasProfileFields() -> Bool {
        if firstName != "" && lastName != "" && email != "" && birthday != "" && gender != "" && uid != "" {
            return true
        }
        return false
    }
    
    func addContact(user: User, relationship: String) {
        let newContactRef = Database.contactsRef.child(self.uid).child(user.uid)
        let selfContactRef = Database.contactsRef.child(user.uid).child(self.uid)
        
        let contactName = user.firstName + " " + user.lastName
        let selfName = self.firstName + " " + self.lastName
        
        var revRelationship: String?
        
        if relationship == "Mother" || relationship == "Father" {
            if (gender == "Female") {
                revRelationship = "Daughter"
            }
            else if (gender == "Male") {
                revRelationship = "Son"
            }
            else {
                revRelationship = "Child"
            }
        }
        else if relationship == "Daughter" || relationship == "Son" {
            if (gender == "Female") {
                revRelationship = "Mother"
            }
            else if (gender == "Male") {
                revRelationship = "Father"
            }
            else {
                revRelationship = "Parent"
            }
        }
        else if relationship == "Wife" || relationship == "Husband" {
            if (gender == "Female") {
                revRelationship = "Wife"
            }
            else if (gender == "Male") {
                revRelationship = "Husband"
            }
            else {
                revRelationship = "Partner"
            }
        }
        else if relationship == "Maternal Grandmother" || relationship == "Maternal Grandfather" {
            if (gender == "Female") {
                revRelationship = "Grandaughter (Daughter)"
            }
            else if (gender == "Male") {
                revRelationship = "Grandson (Daughter)"
            }
            else {
                revRelationship = "Grandchild"
            }
        }
        else if relationship == "Paternal Grandmother" || relationship == "Paternal Grandfather" {
            if (gender == "Female") {
                revRelationship = "Grandaughter (Son)"
            }
            else if (gender == "Male") {
                revRelationship = "Grandson (Son)"
            }
            else {
                revRelationship = "Grandchild"
            }
        }
        else if relationship == "Grandaughter (Daughter)" || relationship == "Grandson (Daughter)" {
            if (gender == "Female") {
                revRelationship = "Maternal Grandmother"
            }
            else if (gender == "Male") {
                revRelationship = "Maternal Grandfather"
            }
            else {
                revRelationship = "Grandparent"
            }
        }
        else if relationship == "Grandaughter (Son)" || relationship == "Grandson (Son)" {
            if (gender == "Female") {
                revRelationship = "Paternal Grandmother"
            }
            else if (gender == "Male") {
                revRelationship = "Paternal Grandfather"
            }
            else {
                revRelationship = "Grandparent"
            }
        }
        else if relationship == "Maternal Aunt" || relationship == "Maternal Uncle" {
            if (gender == "Female") {
                revRelationship = "Neice (Sister)"
            }
            else if (gender == "Male") {
                revRelationship = "Nephew (Sister)"
            }
            else {
                revRelationship = "Neice/Nephew"
            }
        }
        else if relationship == "Paternal Aunt" || relationship == "Paternal Uncle" {
            if (gender == "Female") {
                revRelationship = "Neice (Brother)"
            }
            else if (gender == "Male") {
                revRelationship = "Nephew (Brother)"
            }
            else {
                revRelationship = "Neice/Nephew"
            }
        }
        else if relationship == "Nephew (Sister)" || relationship == "Niece (Sister)" {
            if (gender == "Female") {
                revRelationship = "Maternal Aunt"
            }
            else if (gender == "Male") {
                revRelationship = "Maternal Uncle"
            }
            else {
                revRelationship = "Aunt/Uncle"
            }
        }
        else if relationship == "Nephew (Brother)" || relationship == "Niece (Brother)" {
            if (gender == "Female") {
                revRelationship = "Paternal Aunt"
            }
            else if (gender == "Male") {
                revRelationship = "Paternal Uncle"
            }
            else {
                revRelationship = "Aunt/Uncle"
            }
        }
        else if relationship == "Sister" || relationship == "Brother"{
            if (gender == "Female") {
                revRelationship = "Sister"
            }
            else if (gender == "Male") {
                revRelationship = "Brother"
            }
            else {
                revRelationship = "Sibling"
            }
        }
        else if relationship == "Maternal Cousin" || relationship == "Paternal Cousin"{
                revRelationship = "Cousin"
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
