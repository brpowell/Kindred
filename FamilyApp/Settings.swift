//
//  Settings.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 11/8/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Settings {
    
    var settingOne: Bool?
    var settingTwo: Bool?
    var settingThree: Bool?
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.settingOne = (snapshotValue["settingOne"] as? Bool)!
        self.settingTwo = (snapshotValue["settingTwo"] as? Bool)!
        self.settingThree = (snapshotValue["settingThree"] as? Bool)!
    }
    
}
