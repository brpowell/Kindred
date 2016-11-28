//
//  VC_Members.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/25/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class MemberCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}

class MembersViewController: UIViewController, SlideMenuControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var members: [User] = []
    
    override func viewDidLoad() {
        self.slideMenuController()?.delegate = self
        membersCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell",
                                                      for: indexPath) as! MemberCell
        cell.imageView.image = members[indexPath.item].photo
        cell.imageView.makeProfileFormat()
        cell.label.text = members[indexPath.item].firstName
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
                        self.membersCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
}
