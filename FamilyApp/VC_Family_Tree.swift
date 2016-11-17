//
//  TreeViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import CoreGraphics
import Firebase

class TreeViewController: FamilyController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    var relationships = [String : Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: 1000, height: 1000)      //change this dynamically later
        scrollView.delegate = self
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        var xCoord = 100
        var yCoord = 200
        
        //Add the current user to the tree
        let box = TreeView()
        box.center = CGPoint(x: xCoord,y: yCoord)
        box.setup(name: Database.user.firstName)
        containerView.addSubview(box)
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference(withPath: "contacts").child(Database.user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                
                let contact = Contact(snapshot: snap as! FIRDataSnapshot)
                let person = TreeView()

                if (contact.relationship == "Sister" || contact.relationship == "Brother") {
                    xCoord += 60
                } else {
                    yCoord += 120
                }
                
                person.center = CGPoint(x: xCoord, y: yCoord)
                person.setup(name: contact.name)
                self.containerView.addSubview(person)
            }
        })
        
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
    }
    
    func relationshipMap() {
        let define = [
            "Mother", "Father", "Sister", "Brother",
            "Maternal Grandmother", "Maternal Grandfather",
            "Maternal Aunt", "Maternal Uncle", "Maternal Cousin", "Maternal Niece", "Maternal Nephew",
            "Paternal Grandmother",  "Paternal Grandfather",
            "Paternal Aunt",  "Paternal Uncle", "Paternal Cousin", "Paternal Niece", "Paternal Nephew"
        ]
    
        relationships["Mother"] = 1
        relationships["Father"] = 1
        relationships["Sister"] = 0
        relationships["Brother"] = 0
        relationships["Maternal Grandmother"] = 2
        relationships["Paternal Grandmother"] = 2
        relationships["Maternal Aunt"] = 1
        relationships["Paternal Aunt"] = 1
        relationships["Maternal Uncle"] = 1
        relationships["Paternal Uncle"] = 1
        relationships["Maternal Grandfather"] = 2
        relationships["Paternal Grandfather"] = 2
        relationships["Maternal Cousin"] = 0
        relationships["Paternal Cousin"] = 0
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
