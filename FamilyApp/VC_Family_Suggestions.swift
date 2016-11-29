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
    var profileImages = [String: UIImage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        let userContactsRef = Database.contactsRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        var contacts: [Contact] = []
        
        userContactsRef.observe(.value, with: { snapshot in
            var newContacts: [Contact] = []
            
            for contact in snapshot.children {
                let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                newContacts.append(contact)
            }
            contacts = newContacts
            
            for con in contacts {
                let userRef = Database.contactsRef.child((con.uid))
                userRef.observe( .value, with: {
                    snapshot in
                    var newSuggestions: [Suggestion] = []
                    for contact in snapshot.children {
                        let contact = Contact(snapshot: contact as! FIRDataSnapshot)
                        if !contacts.contains(contact) {
                            if !(contact.uid == FIRAuth.auth()?.currentUser?.uid) {
                                let rel = self.getSuggestedRelationship(contactRelationshipToMe: con.relationship, otherRelationshipToContact: contact.relationship)
                        let sug = Suggestion(name: contact.name, uid: contact.uid, relationship: rel)
                        newSuggestions.append(sug)
                            }
                        }
                    }
                    for suggest in newSuggestions {
                        if !(self.suggestions.contains(suggest)) {
                            self.suggestions.append(suggest)
                            let uid = suggest.uid
                            let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + suggest.uid)
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
                        }
                    }
                    
                })
            }
        })
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func getSuggestedRelationship(contactRelationshipToMe: String, otherRelationshipToContact: String) -> String {
        var gender = ProfileViewController.user?.gender
        if (contactRelationshipToMe == "Brother") {
            if (otherRelationshipToContact == "Son") {
                return "Nephew (Brother)"
            }
            if (otherRelationshipToContact == "Daughter") {
                return "Niece (Brother)"
            }
            if (otherRelationshipToContact == "Wife" || otherRelationshipToContact == "Husband" || otherRelationshipToContact == "Granddaughter (Daughter)" || otherRelationshipToContact == "Granddaughter (Son)" || otherRelationshipToContact == "Grandson (Daughter)" || otherRelationshipToContact == "Grandson (Son)" || otherRelationshipToContact == "Niece (Sister)" || otherRelationshipToContact == "Nephew (Sister)" || otherRelationshipToContact == "Niece (Brother)" || otherRelationshipToContact == "Newphew (Brother)") {
                return "Potential Relative"
            }
            else {
                return otherRelationshipToContact;
            }
        }
        if (contactRelationshipToMe == "Sister") {
            if (otherRelationshipToContact == "Son") {
                return "Nephew (Sister)"
            }
            if (otherRelationshipToContact == "Daughter") {
                return "Niece (Sister)"
            }
            if (otherRelationshipToContact == "Wife" || otherRelationshipToContact == "Husband" || otherRelationshipToContact == "Granddaughter (Daughter)" || otherRelationshipToContact == "Granddaughter (Son)" || otherRelationshipToContact == "Grandson (Daughter)" || otherRelationshipToContact == "Grandson (Son)" || otherRelationshipToContact == "Niece (Sister)" || otherRelationshipToContact == "Nephew (Sister)" || otherRelationshipToContact == "Niece (Brother)" || otherRelationshipToContact == "Newphew (Brother)") {
                return "Potential Relative"
            }
            else {
                return otherRelationshipToContact;
            }
        }
        if (contactRelationshipToMe == "Mother") {
            if (otherRelationshipToContact == "Mother") {
                return "Maternal Grandmother"
            }
            if (otherRelationshipToContact == "Father") {
                return "Maternal Grandfather"
            }
            if (otherRelationshipToContact == "Sister") {
                return "Maternal Aunt"
            }
            if (otherRelationshipToContact == "Brother") {
                return "Maternal Uncle"
            }
            if (otherRelationshipToContact == "Niece (Sister)" || otherRelationshipToContact == "Nephew (Sister)" || otherRelationshipToContact == "Niece (Brother)" || otherRelationshipToContact == "Nephew (Brother)") {
                return "Maternal Cousin"
            }

        }
        if (contactRelationshipToMe == "Father") {
            if (otherRelationshipToContact == "Mother") {
                return "Paternal Grandmother"
            }
            if (otherRelationshipToContact == "Father") {
                return "Paternal Grandfather"
            }
            if (otherRelationshipToContact == "Sister") {
                return "Paternal Aunt"
            }
            if (otherRelationshipToContact == "Brother") {
                return "Paternal Uncle"
            }
            if (otherRelationshipToContact == "Niece (Sister)" || otherRelationshipToContact == "Nephew (Sister)" || otherRelationshipToContact == "Niece (Brother)" || otherRelationshipToContact == "Nephew (Brother)") {
                return "Paternal Cousin"
            }
            
        }
        if (contactRelationshipToMe == "Mother" || contactRelationshipToMe == "Father") {
            if (otherRelationshipToContact == "Son") {
                return "Brother"
            }
            if (otherRelationshipToContact == "Daughter") {
                return "Sister"
            }
            if (otherRelationshipToContact == "Wife") {
                return "Mother"
            }
            if (otherRelationshipToContact == "Husband") {
                return "Father"
            }
        }
        if (contactRelationshipToMe == "Wife" || contactRelationshipToMe == "Husband") {
            if (otherRelationshipToContact == "Daughter" || otherRelationshipToContact == "Son") {
                return otherRelationshipToContact
            }
        }
        if (contactRelationshipToMe == "Son" || contactRelationshipToMe == "Daughter") {
            if (otherRelationshipToContact == "Brother") {
                return "Son"
            }
            if (otherRelationshipToContact == "Sister") {
                return "Daughter"
            }
            if (otherRelationshipToContact == "Mother") {
                return "Wife"
            }
            if (otherRelationshipToContact == "Father") {
                return "Husband"
            }
            if (otherRelationshipToContact == "Paternal Uncle" && gender == "Male") {
                return "Brother"
            }
            if (otherRelationshipToContact == "Maternal Uncle" && gender == "Female") {
                return "Brother"
            }
            if (otherRelationshipToContact == "Paternal Aunt" && gender == "Male") {
                return "Sister"
            }
            if (otherRelationshipToContact == "Maternal Aunt" && gender == "Female") {
                return "Sister"
            }
        }
        if (contactRelationshipToMe == "Son") {
            if (otherRelationshipToContact == "Son") {
                return "Grandson (Son)"
            }
            if (otherRelationshipToContact == "Daughter") {
                return "Granddaughter (Son)"
            }
        }
        if (contactRelationshipToMe == "Daughter") {
            if (otherRelationshipToContact == "Son") {
                return "Grandson (Daughter)"
            }
            if (otherRelationshipToContact == "Daughter") {
                return "Granddaughter (Daughter)"
            }
        }
        
        return "Potential Relative"
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let uid = suggestions[row].uid
        Database.usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let u = User(snapshot: snapshot)
            let cell = tableView.cellForRow(at: indexPath) as! SuggestionTableViewCell
            u.photo = cell.profilePic.image
            OtherProfileViewController.user = u
            self.performSegue(withIdentifier: "profileSegue", sender: self)
        })
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SuggestionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SuggestionTableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = suggestions[row].name
        cell.relationshipLabel.text = suggestions[row].relationship
        cell.index = row
        cell.delegate = self
        cell.profilePic.image = profileImages[suggestions[row].uid]
        cell.profilePic.makeProfileFormat(width: 0)
        cell.addButton.isHidden = false;
        cell.addButton.isEnabled = true;
        cell.addedLabel.isHidden = true;
        
        return cell
    }
    
    func addNewContact(conIndex: Int, suggestedRelationship: String) {
        let myUID = FIRAuth.auth()?.currentUser?.uid
        let suggestion = suggestions[conIndex]
        let otherUid = suggestion.uid
        let newContactRef = Database.contactsRef.child(myUID!).child(otherUid)
        let selfContactRef = Database.contactsRef.child(otherUid).child(myUID!)
        let contactName = suggestions[conIndex].name
        let selfName = FIRAuth.auth()?.currentUser?.displayName
        let revRelationship = getReverseRelationship(relationship: suggestedRelationship)
        let relationship = suggestedRelationship
        let newContact = Contact(name: contactName, relationship: relationship, uid: otherUid)
        let selfContact = Contact(name: selfName!, relationship: revRelationship, uid: myUID!)
        newContactRef.setValue(newContact.toAnyObject())
        selfContactRef.setValue(selfContact.toAnyObject())
        suggestions.remove(at: conIndex)
        self.tableView.reloadData()
        print("Contact added!")
    }
    
    func getReverseRelationship(relationship: String) -> String {
        var revRelationship: String
        var gender = Database.user.gender
        print(gender);
        if relationship == "Mother" || relationship == "Father" {
            if (gender == "Female") {
                revRelationship = "Daughter"
            }
            else if (gender == "Male") {
                revRelationship = "Son"
            }
            else {
                revRelationship = "Child"
            }
        }
        else if relationship == "Daughter" || relationship == "Son" {
            if (gender == "Female") {
                revRelationship = "Mother"
            }
            else if (gender == "Male") {
                revRelationship = "Father"
            }
            else {
                revRelationship = "Parent"
            }
        }
        else if relationship == "Wife" || relationship == "Husband" {
            if (gender == "Female") {
                revRelationship = "Wife"
            }
            else if (gender == "Male") {
                revRelationship = "Husband"
            }
            else {
                revRelationship = "Partner"
            }
        }
        else if relationship == "Maternal Grandmother" || relationship == "Maternal Grandfather" {
            if (gender == "Female") {
                revRelationship = "Granddaughter (Daughter)"
            }
            else if (gender == "Male") {
                revRelationship = "Grandson (Daughter)"
            }
            else {
                revRelationship = "Grandchild"
            }
        }
        else if relationship == "Paternal Grandmother" || relationship == "Paternal Grandfather" {
            if (gender == "Female") {
                revRelationship = "Granddaughter (Son)"
            }
            else if (gender == "Male") {
                revRelationship = "Grandson (Son)"
            }
            else {
                revRelationship = "Grandchild"
            }
        }
        else if relationship == "Granddaughter (Daughter)" || relationship == "Grandson (Daughter)" {
            if (gender == "Female") {
                revRelationship = "Maternal Grandmother"
            }
            else if (gender == "Male") {
                revRelationship = "Maternal Grandfather"
            }
            else {
                revRelationship = "Grandparent"
            }
        }
        else if relationship == "Granddaughter (Son)" || relationship == "Grandson (Son)" {
            if (gender == "Female") {
                revRelationship = "Paternal Grandmother"
            }
            else if (gender == "Male") {
                revRelationship = "Paternal Grandfather"
            }
            else {
                revRelationship = "Grandparent"
            }
        }
        else if relationship == "Maternal Aunt" || relationship == "Maternal Uncle" {
            if (gender == "Female") {
                revRelationship = "Neice (Sister)"
            }
            else if (gender == "Male") {
                revRelationship = "Nephew (Sister)"
            }
            else {
                revRelationship = "Neice/Nephew"
            }
        }
        else if relationship == "Paternal Aunt" || relationship == "Paternal Uncle" {
            if (gender == "Female") {
                revRelationship = "Neice (Brother)"
            }
            else if (gender == "Male") {
                revRelationship = "Nephew (Brother)"
            }
            else {
                revRelationship = "Neice/Nephew"
            }
        }
        else if relationship == "Nephew (Sister)" || relationship == "Niece (Sister)" {
            if (gender == "Female") {
                revRelationship = "Maternal Aunt"
            }
            else if (gender == "Male") {
                revRelationship = "Maternal Uncle"
            }
            else {
                revRelationship = "Aunt/Uncle"
            }
        }
        else if relationship == "Nephew (Brother)" || relationship == "Niece (Brother)" {
            if (gender == "Female") {
                revRelationship = "Paternal Aunt"
            }
            else if (gender == "Male") {
                revRelationship = "Paternal Uncle"
            }
            else {
                revRelationship = "Aunt/Uncle"
            }
        }
        else if relationship == "Sister" || relationship == "Brother"{
            if (gender == "Female") {
                revRelationship = "Sister"
            }
            else if (gender == "Male") {
                revRelationship = "Brother"
            }
            else {
                revRelationship = "Sibling"
            }
        }
        else if relationship == "Maternal Cousin" || relationship == "Paternal Cousin" || relationship == "Cousin"{
            revRelationship = "Cousin"
        }
        else {
            revRelationship = relationship
        }
        return revRelationship
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
