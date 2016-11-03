//
//  CreateGroupsViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsViewController: InputViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var groupNameField: FATextField!
    
    @IBOutlet weak var tableView: UITableView!
    var ref: FIRDatabaseReference!
    var contacts = [Contact]()
    let textCellIdentifier = "contactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        
        ref = FIRDatabase.database().reference(withPath: "contacts").child("\(Database.user.uid)")
        ref.observe(.value, with: { snapshot in
            for person in snapshot.children {
                let snap = person as! FIRDataSnapshot
                let contact = Contact(snapshot: snap)
                
                self.contacts.append(contact)
                self.tableView.reloadData()
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreateGroupButton(_ sender: AnyObject) {
        let userId = Database.user.uid
        let groupName = groupNameField.textField.text!
        if (!groupName.isEmpty) {
            Database.db.createGroup(groupName: groupNameField.textField.text!, userId: userId)

        } else {
            
            Alerts.okError(title: "No Members", message: "Please select 1 or more to join your group", viewController: self)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = contacts[row].name
        cell.detailTextLabel?.text = contacts[row].relationship
        
        let image = UIImage(named: "uncheckedIcon")
        cell.imageView?.image = image
        
        let selectedImage = UIImage(named: "checkedIcon")
        selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        cell.imageView?.highlightedImage = selectedImage
        cell.imageView?.tintColor = FAColor.lightGreen
        
//        if(cell.isSelected) {
//           cell.backgroundColor = UIColor.clear
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
}
