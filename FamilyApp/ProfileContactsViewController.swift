//
//  ProfileContactsViewController.swift
//  FamilyApp
//
//  Created by Apurva Gorti on 10/31/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class ProfileContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static var user: User?
    
    var contacts = [Contact]()
    var myContacts = [Contact]()
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = OtherProfileViewController.user
        
        let userContactsRef = Database.contactsRef.child((user!.uid))
        
        let myUserContactsRef = Database.contactsRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        
        
        myUserContactsRef.observe(.value, with: { snapshot in
            var myNewContacts: [Contact] = []
            for contact in snapshot.children {
                let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                    myNewContacts.append(contact)
            }
            self.myContacts = myNewContacts
        })
        
        print(myContacts)
        print ("WHATS UP")
        
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
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
