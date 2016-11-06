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
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userContactsRef = Database.contactsRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        userContactsRef.observe(.value, with: { snapshot in
            var newContacts: [Contact] = []
            
            for contact in snapshot.children {
                let contact = Contact(snapshot: contact as! FIRDataSnapshot)
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
            let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + u.uid)
            
            if let image = Database.profileImageCache.object(forKey: NSString(string: u.uid)) {
                u.photo = image
                OtherProfileViewController.user = u
                self.performSegue(withIdentifier: "profileSegue", sender: self)
            }
            else {
                profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        u.photo = UIImage(data: data!)
                        OtherProfileViewController.user = u
                        self.performSegue(withIdentifier: "profileSegue", sender: self)
                    }
                }
            }
        
        })
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = contacts[row].name
        cell.detailTextLabel?.text = contacts[row].relationship
        
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
