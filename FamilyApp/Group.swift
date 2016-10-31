//
//  Group.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/27/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Group {

    var name: String
    var groupId: String
    
    init(name: String, groupId: String) {
        self.name = name
        self.groupId = groupId
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = (snapshotValue["name"] as? String)!
        self.groupId = snapshot.key
    }
    
}
