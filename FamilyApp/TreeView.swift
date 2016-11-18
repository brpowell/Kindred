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
        
        //Draw the box that has the name and profile picture
        box.backgroundColor = UIColor.clear
        box.layer.borderColor = UIColor(red:0.21, green:0.46, blue:0.83, alpha:1.0).cgColor
        box.layer.borderWidth = 1.1
        addSubview(box)
        
        //Draw the circle for the profile picture inside the box
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 25, y: 30), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red:0.21, green:0.46, blue:0.83, alpha:1.0).cgColor
        shapeLayer.lineWidth = 1.1
        layer.addSublayer(shapeLayer)
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
