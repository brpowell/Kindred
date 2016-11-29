//
//  SuggestionTableViewCell.swift
//  Pods
//
//  Created by Apurva Gorti on 10/19/16.
//
//

import UIKit

protocol AddContactDelegate {
    func addNewContact(conIndex: Int, suggestedRelationship: String)
}

class SuggestionTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var index: Int = 0
    
    var delegate: AddContactDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressAdd(_ sender: Any) {
        addButton.isEnabled = false;
        delegate?.addNewContact(conIndex: index, suggestedRelationship: relationshipLabel.text!)
    }
    
    

}
