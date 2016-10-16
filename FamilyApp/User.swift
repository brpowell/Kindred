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
    
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let birthday: String
    
    static var activeUserImage: UIImage?
    
    init(authData: FIRUser, firstName: String, lastName: String, birthday: String) {
        uid = authData.uid
        email = authData.email!
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
    
    func toAnyObject() -> [String: String] {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday
        ]
    }
    
}
