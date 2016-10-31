//
//  GroupsViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/11/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: FIRDatabaseReference!
    var groups = [Group]()
    let textCellIdentifier = "groupCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference(withPath: "users").child("\(Database.user.uid)/\("groups")")
        ref.observe(.value, with: { snapshot in
            self.groups.removeAll()
            for group in snapshot.children {
                let snap = group as! FIRDataSnapshot
                let groupId = snap.key
                
                let groupRef = FIRDatabase.database().reference(withPath: "groups").child("\(groupId)")
                groupRef.observe(.value, with: { snapshot in
                    let g = Group(snapshot: snapshot)
                    self.groups.append(g)
                    self.tableView.reloadData()
                })
            }
            
            self.tableView.reloadData()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let group = groups[indexPath.row]
        print(group.name)
        print(group.groupId)
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = groups[row].name
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }

}
