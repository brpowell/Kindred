//
//  User.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let birthday: String
    
    init(authData: FIRUser, firstName: String, lastName: String, birthday: String) {
        uid = authData.uid
        email = authData.email!
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday
        ]
    }
    
}
