//
//  FamilyViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/11/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class ContactsViewController: FamilyController, UITableViewDataSource, UITableViewDelegate {

//    @IBOutlet weak var contactsBarButton: UITabBarItem!
//    @IBOutlet weak var tabBar: UITabBar!
    
    let apurva = Contact(firstName:"Apurva", lastName:"Gorti", birthday: "Oct 10, 1996")
    let uyviet = Contact(firstName:"Uyviet", lastName:"Nguyen", birthday: "Aug 11, 2013")
    let bryan = Contact(firstName:"Bryan", lastName:"Powell", birthday: "Jan 1, 1960")
    
    var contacts = [Contact]()
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apurva.relationship = "Sister"
        uyviet.relationship = "Brother"
        bryan.relationship = "First Cousin"
        
        contacts.append(apurva)
        contacts.append(uyviet)
        contacts.append(bryan)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = contacts[row].firstName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(contacts[row])
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = contacts[row].firstName
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
