//
//  FamilyViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/11/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: FamilyController, UITableViewDataSource, UITableViewDelegate {

//    @IBOutlet weak var contactsBarButton: UITabBarItem!
//    @IBOutlet weak var tabBar: UITabBar!
    
    var contacts = [Contact]()
    var profileImages = [String : UIImage]()
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userContactsRef = Database.contactsRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        userContactsRef.observe(.value, with: { snapshot in
            var newContacts: [Contact] = []
            
            for contact in snapshot.children {
                let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                let uid = contact.uid
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + uid)
                profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        let image = UIImage(data: data!)
                        self.profileImages[uid] = image
                        self.tableView.reloadData()
                    }
                }
                newContacts.append(contact)
            }
            
            self.contacts = newContacts
            self.tableView.reloadData()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let contact = contacts[indexPath.row]
        Database.usersRef.child(contact.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let u = User(snapshot: snapshot)
            let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
            u.photo = cell.profilePic.image
            OtherProfileViewController.user = u
            self.performSegue(withIdentifier: "profileSegue", sender: self)
        
        })
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath) as! ContactTableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = contacts[row].name
        cell.relationshipLabel.text = contacts[row].relationship
        cell.profilePic.image = profileImages[contacts[row].uid]
        cell.profilePic.makeProfileFormat(width: 0)
        
        return cell
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
