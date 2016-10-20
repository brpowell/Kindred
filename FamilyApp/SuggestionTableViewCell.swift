//
//  SuggestionTableViewCell.swift
//  Pods
//
//  Created by Apurva Gorti on 10/19/16.
//
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
