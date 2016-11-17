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
import Firebase

class TreeViewController: FamilyController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var xCoord = 100
        var yCoord = 100
        
        //Add the current user to the tree
        let box = TreeView()
        box.center = CGPoint(x: xCoord,y: yCoord)
        box.setup(name: Database.user.firstName)
        self.view.addSubview(box)
        
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference(withPath: "contacts").child(Database.user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for person in snapshot.children {
                xCoord += 60
                
                let snap = person as! FIRDataSnapshot
                let user = Contact(snapshot: snap)
                
                let new = TreeView()
                new.center = CGPoint(x: xCoord, y: yCoord)
                new.setup(name: user.name)
                self.view.addSubview(new)
            }
        })
        
        
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
