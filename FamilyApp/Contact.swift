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

class Contact : Equatable{
    
//    static let generationMap = {
//        "Grandmother": -2,
//        "Grandfather": -2,
//        "Grandparent": -2,
//        "Granduncle": -2,
//        "Grandaunt": -2,
//        "Mother": -1,
//        "Father": -1,
//        "Uncle": -1,
//        "Aunt": -1,
//        "Brother": 0,
//        "Sister": 0,
//        "Son": 1,
//        "Daughter": 1
//    }
    
    var name: String
//    var birthday: String
    var relationship: String
    var uid: String
    
    init(name: String, relationship: String, uid: String) {
        self.name = name
        self.relationship = relationship
        self.uid = uid
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = (snapshotValue["name"] as? String)!
        self.relationship = (snapshotValue["relationship"] as? String)!
        print(snapshot)
        self.uid = snapshot.key
    }
    
    func toAnyObject() -> [String: String] {
        return [
            "name": name,
            "relationship": relationship
        ]
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.uid == rhs.uid
    }
}
