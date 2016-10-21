//
//  RelationPopoverViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class RelationPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let relationships = [
        "Mother", "Father", "Sister", "Brother",
        "Aunt", "Uncle", "First Cousin", "Nephew", "Niece",
        "Grandmother", "Grandfather", "Granddaughter", "Grandson"
    ]
    
    let textCellIdentifier = "RelationCell"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relationships.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = relationships[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let user = OtherProfileViewController.user
        let userName = (user?.firstName)! + " " + (user?.lastName)!
        let row = indexPath.row
        let message = "Are you sure you want to add " + userName + " as your " + relationships[row] + "?"
        
        let controller = UIAlertController(title: "Add Contact", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Yes",style: .default, handler: {
            (paramAction:UIAlertAction!) in
            
            Database.user.addContact(user: user!, relationship: self.relationships[row])
            print(String(self.relationships[row]) + " added")
        }))
        present(controller, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = relationships[row]
        cell.detailTextLabel?.text = relationships[row]
        
        return cell
    }
    
}
