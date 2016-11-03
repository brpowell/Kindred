//
//  Alerts.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/2/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    
    static func okError(title: String, message: String, viewController: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
}
