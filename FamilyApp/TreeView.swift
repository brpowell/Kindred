//
//  FamilyMemberView.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 11/15/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import UIKit

class TreeView: UIView {
    
    var name: String?
    var proPicURL: URL?
    var profilePicture = UIImageView()
    var box = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        box.backgroundColor = UIColor.clear
        box.layer.borderColor = UIColor.green.cgColor
        box.layer.borderWidth = 1
        addSubview(box)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        label.center = CGPoint(x: 25, y: 90)
        label.textAlignment = .center
        label.text = name
        label.font = label.font.withSize(10)
        label.textColor = UIColor.black
        addSubview(label)
    }

}
