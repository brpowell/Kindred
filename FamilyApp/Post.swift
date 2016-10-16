//
//  Post.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/14/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Post {
    var key: String?
    var name: String?
    var body: String?
    var timestamp: TimeInterval?
    var uid: String?
    var profile: UIImage?
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.name = snapshotValue["author"] as? String
        self.body = snapshotValue["body"] as? String
        self.timestamp = snapshotValue["timestamp"] as? TimeInterval
        self.uid = snapshotValue["uid"] as? String
    }
}
