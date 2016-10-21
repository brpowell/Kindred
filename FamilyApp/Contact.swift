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
}
