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

class Suggestion: Equatable {
    
    var name: String
    var uid: String
    var relationship: String
    
    init(name: String, uid: String, relationship: String) {
        self.name = name
        self.uid = uid
        self.relationship = relationship
    }
    
    static func == (lhs: Suggestion, rhs: Suggestion) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}
