//
//  Contact.swift
//  FamilyApp
//
//  Created by Apurva Gorti on 10/18/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Contact {
    
    var firstName: String
    var lastName: String
    var birthday: String
    
    
    init(firstName: String, lastName: String, birthday: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
}
