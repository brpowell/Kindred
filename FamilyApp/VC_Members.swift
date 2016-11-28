//
//  VC_Members.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/25/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SlideMenuControllerDelegate {
    
    @IBOutlet weak var membersTableView: UITableView!
    
    var members: [User] = []
    
    override func viewDidLoad() {
        self.slideMenuController()?.delegate = self
        membersTableView.dataSource = self
        membersTableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

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
    
    func populateMembers(uids: [String]) {
        self.members.removeAll()
        
        for uid in uids {
            Database.usersRef.child(uid).observeSingleEvent(of: .value, with: { snapshot in
                let u = User(snapshot: snapshot)
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + u.uid)
                profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        u.photo = UIImage(data: data!)
                        self.members.append(u)
                        self.membersTableView.reloadData()
                    }
                }
            })
        }
    }
    
}
