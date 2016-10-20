//
//  SuggestionsViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/16/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class SuggestionsViewController: FamilyController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    let apurva = Suggestion(firstName:"Harry", lastName:"Potter", relationship: "brother")
    let uyviet = Suggestion(firstName:"Albus", lastName:"Dumbledor", relationship: "grandfather")
    let bryan = Suggestion(firstName:"Hermione", lastName:"Granger", relationship: "second cousin")
    
    var suggestions = [Suggestion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        suggestions.append(apurva)
        suggestions.append(uyviet)
        suggestions.append(bryan)
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
        cell.nameLabel.text = suggestions[row].firstName + " " + suggestions[row].lastName
        cell.relationshipLabel.text = suggestions[row].relationship
        
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
