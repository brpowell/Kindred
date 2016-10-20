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

class Suggestion {
    
    var firstName: String
    var lastName: String
    var relationship: String
    
    init(firstName: String, lastName: String, relationship: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.relationship = relationship
    }
}
