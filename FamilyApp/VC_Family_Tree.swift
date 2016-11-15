//
//  TreeViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import CoreGraphics
import SpriteKit

class TreeViewController: FamilyController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//        //change the fill color
//        shapeLayer.fillColor = UIColor.blue.cgColor
//        //you can change the stroke color
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        //you can change the line width
//        shapeLayer.lineWidth = 3.0
//        view.layer.addSublayer(shapeLayer)

        
        
        
        drawFamilyMember(name: Database.user.firstName, xCoor: 200, yCoor: 200)
        
        
        
    }
    
    func drawFamilyMember(name: String, xCoor: Int, yCoor: Int) {
        let size:CGFloat = 60.0 // 35.0 chosen arbitrarily
        let countLabel = UILabel()
        countLabel.text = name
        countLabel.textColor = UIColor.green
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 14.0)
        countLabel.bounds = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        countLabel.layer.cornerRadius = size / 2
        countLabel.layer.borderWidth = 3.0
        countLabel.layer.backgroundColor = UIColor.clear.cgColor
        countLabel.layer.borderColor = UIColor.green.cgColor
        countLabel.center = CGPoint(x: xCoor,y: yCoor)
        self.view.addSubview(countLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        search()
    }

}
