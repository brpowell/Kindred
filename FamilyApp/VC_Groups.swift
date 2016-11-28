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

    override func viewDidAppear(_ animated: Bool) {
        self.slideMenuController()?.removeRightGestures()
    }
    
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
                    if (snapshot.exists()) {
                        let g = Group(snapshot: snapshot)
                        self.groups.append(g)
                        self.tableView.reloadData()
                    }
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
        
        let group = groups[indexPath.item]
        let ref = FIRDatabase.database().reference(withPath: "groups").child(group.groupId).child("members")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var members = [String]()
            for member in snapshot.children {
                let snap = member as! FIRDataSnapshot
                members.append(snap.key)
            }
            let vc = self.slideMenuController()?.rightViewController as? MembersViewController
            vc?.populateMembers(uids: members)
            vc?.nameLabel.text = group.name + " (\(members.count))"
            self.performSegue(withIdentifier: "chatSegue", sender: self)
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue",
            let destination = segue.destination as? ChatViewController,
            let index = tableView.indexPathForSelectedRow?.row
        {
            let group = groups[index]
            destination.group = group
        }
        
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
