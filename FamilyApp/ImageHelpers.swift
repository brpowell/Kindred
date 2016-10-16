//
//  ImageHelpers.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeProfileFormat() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}
