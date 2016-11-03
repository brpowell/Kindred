//
//  SuggestionsViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class SuggestionsViewController: FamilyController, UITableViewDataSource, UITableViewDelegate, AddContactDelegate {

    @IBOutlet weak var tableView: UITableView!


    
    var suggestions = [Suggestion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        let userContactsRef = Database.contactsRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        var contacts: [Contact] = []
        
        userContactsRef.observeSingleEvent(of: .value, with: { snapshot in
            var newContacts: [Contact] = []
            
            for contact in snapshot.children {
                let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                newContacts.append(contact)
            }
            contacts = newContacts
            
            for con in contacts {
                let userRef = Database.contactsRef.child((con.uid))
                userRef.observeSingleEvent(of: .value, with: {
                    snapshot in
                    var newSuggestions: [Suggestion] = []
                    for contact in snapshot.children {
                        let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                        if !contacts.contains(contact) {
                        
                        let sug = Suggestion(name: contact.name, uid: contact.uid, relationship: "Potential Family Relationship")
                        newSuggestions.append(sug)
                        }
                    }
                    for suggest in newSuggestions {
                        if !(self.suggestions.contains(suggest)) {
                            self.suggestions.append(suggest)
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(suggestions[row])
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SuggestionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SuggestionTableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = suggestions[row].name
        cell.relationshipLabel.text = suggestions[row].relationship
        cell.index = row

        
        return cell
    }
    
    func addNewContact(conIndex: Int) {
        let myUID = FIRAuth.auth()?.currentUser?.uid
        let suggestion = suggestions[conIndex]
        let otherUid = suggestion.uid
        let newContactRef = Database.contactsRef.child(myUID!).child(otherUid)
        let selfContactRef = Database.contactsRef.child(otherUid).child(myUID!)
        let contactName = suggestions[conIndex].name
        let selfName = FIRAuth.auth()?.currentUser?.displayName
        let revRelationship = "suggested Relationship"
        let relationship = "suggested Relationship"
        let newContact = Contact(name: contactName, relationship: relationship, uid: otherUid)
        let selfContact = Contact(name: selfName!, relationship: revRelationship, uid: myUID!)
        newContactRef.setValue(newContact.toAnyObject())
        selfContactRef.setValue(selfContact.toAnyObject())
        print("Contact added!")
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
