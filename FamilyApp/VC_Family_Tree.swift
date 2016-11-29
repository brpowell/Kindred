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
    var generationMap = [String : Int]()
    var xCoordMap = [Int : Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: 1000, height: 1000)      //change this dynamically later
        scrollView.delegate = self
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        relationshipMap()   //add relationships to the map for generation
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
                let generation = self.generationMap[contact.relationship]
                
                var newY = yCoord
                
                if (generation != nil) {
                    newY += generation!*120
                    xCoord += 60
                } else {
                    newY += -120
                    xCoord += 60
                }
                
                person.center = CGPoint(x: xCoord, y: newY)
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
            "Son", "Daughter", "Wife", "Husband",
            "Maternal Grandmother", "Maternal Grandfather",
            "Grandaughter (Daughter)", "Grandson (Daughter)",
            "Maternal Aunt", "Maternal Uncle", "Maternal Cousin", "Niece (Sister)", "Nephew (Sister)",
            "Paternal Grandmother",  "Paternal Grandfather",
            "Grandaughter (Daughter)", "Grandson (Daughter)",
            "Paternal Aunt",  "Paternal Uncle", "Paternal Cousin", "Niece (Brother)", "Nephew (Brother)"
        ]
    
        generationMap["Mother"] = -1
        generationMap["Father"] = -1
        generationMap["Sister"] = 0
        generationMap["Brother"] = 0
        generationMap["Maternal Grandmother"] = -2
        generationMap["Paternal Grandmother"] = -2
        generationMap["Maternal Aunt"] = -1
        generationMap["Paternal Aunt"] = -1
        generationMap["Maternal Uncle"] = -1
        generationMap["Paternal Uncle"] = -1
        generationMap["Maternal Grandfather"] = -2
        generationMap["Paternal Grandfather"] = -2
        generationMap["Maternal Cousin"] = 0
        generationMap["Paternal Cousin"] = 0
        generationMap["Son"] = 1
        generationMap["Daughter"] = 1
        generationMap["Niece (Sister)"] = 1
        generationMap["Nephew (Sister)"] = 1
        generationMap["Niece (Brother)"] = 1
        generationMap["Nephew (Brother)"] = 1
        generationMap["Granddaughter (Daughter)"] = 2
        generationMap["Granddaughter (Son)"] = 2
        generationMap["Grandson (Daughter)"] = 2
        generationMap["Grandson (Son)"] = 2
        generationMap["Wife"] = 0
        generationMap["Husband"] = 0
        
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
