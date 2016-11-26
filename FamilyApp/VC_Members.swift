//
//  VC_Members.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/25/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SlideMenuControllerDelegate {
    
    @IBOutlet weak var membersTableView: UITableView!
    
    static var members: [User] = []
    var members: [User] = []
    
    override func viewDidLoad() {
        self.slideMenuController()?.delegate = self
        membersTableView.dataSource = self
        membersTableView.delegate = self
    }
    
//    func rightWillOpen() {
//        members = MembersViewController.members
//        print("Members: " + String(members.count))
//        print("Static Members: " + String(MembersViewController.members.count))
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        members.removeAll()
        MembersViewController.members.removeAll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Members: " + String(members.count))
        print("Static Members: " + String(MembersViewController.members.count))
        members = MembersViewController.members
        membersTableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = members[row].firstName
        
        return cell
    }
    
}
