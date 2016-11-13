//
//  TreeViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import CoreGraphics

class TreeViewController: FamilyController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer)
    
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
