//
//  FeedView.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/14/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell {
    
    static var postImageCache = NSCache<NSString, UIImage>()
    var feedController: FeedViewController?
    
    func animate() {
        feedController?.animateImageView(postImageView: postImageView)
    }
    
    func viewProfile() {
        if let uid = self.post?.uid {
            Database.usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let u = User(snapshot: snapshot)
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + u.uid)
                
                if let image = Database.profileImageCache.object(forKey: NSString(string: u.uid)) {
                    u.photo = image
                    OtherProfileViewController.user = u
                    self.feedController?.performSegue(withIdentifier: "profileSegue", sender: self)
                }
                else {
                    profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            u.photo = UIImage(data: data!)
                            OtherProfileViewController.user = u
                            self.feedController?.performSegue(withIdentifier: "profileSegue", sender: self)
                        }
                    }
                }
            })
        }
    }
    
    var post: Post? {
        didSet {
            if ((post?.name) != nil) {
                loadNameLabel()
            }
            
            if let body = post?.body {
                bodyTextView.text = body
            }
            
            if let profileImage = post?.profile {
                profileImageView.image = profileImage
            }
            else {
                profileImageView.image = UIImage(named: "profile")
            }
            
            // Add user to user cache if they don't exist, save their post
            let uid = NSString(string: (post?.uid)!)
            var user = Database.userCache.object(forKey: uid)
            if user != nil {
                user?.posts?[(post?.key)!] = post
            }
            else {
                let name = post?.name?.components(separatedBy: " ")
                user = User()
                user?.firstName = (name?[0])!
                user?.lastName = (name?[1])!
                user?.posts?[(post?.key)!] = post
                Database.userCache.setObject(user!, forKey: uid)
            }
            
            // Check if user has a profile image downloaded, if not fetch one and add to cache
            if let image = user?.photo {
                profileImageView.image = image
            }
            else {
                let profileImageRef = Database.profileImagesRef.child(uid as String)
                profileImageRef.data(withMaxSize: Database.maxDataSize, completion: { data, error in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            user?.photo = image
                            self.profileImageView.image = image
                            Database.userCache.object(forKey: uid)?.posts?[(self.post?.key)!] = self.post
                        }
                    }
                })
            }
            
            // Load post image if one exists
            if (post?.hasImage)! {
                if let image = FeedCell.postImageCache.object(forKey: NSString(string: (self.post?.key)!)) {
                    postImageView.image = image
                }
                else {
                    let postImageRef = Database.postImagesRef.child((post?.key)!)
                    postImageRef.data(withMaxSize: 1024*1024) { data, error in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            DispatchQueue.main.async {
                                let image = UIImage(data: data!)
                                let key: NSString = NSString(string: (self.post?.key)!)
                                FeedCell.postImageCache.setObject(image!, forKey: key)
                                self.postImageView.image = image
                            }
                        }
                    }
                }
            }
            
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // Timestamp refresher
    func loadNameLabel() {
        let attributedText = NSMutableAttributedString(string: (self.post?.name!)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        
        let dateFormatter = DateFormatter()
        let delta = (self.post?.timestamp)! / 1000
        let date = "\n" + dateFormatter.timeSince(from: NSDate(timeIntervalSince1970: delta), numericDates: true)
        
        attributedText.append(NSAttributedString(string: date, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
        nameLabel.attributedText = attributedText
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    

    func setupViews() {
        backgroundColor = UIColor.white
        
        // Rounded corner effect
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        bodyTextView.layer.cornerRadius = 6.0
        postImageView.layer.cornerRadius = 6.0
        
        // Shadow effect
        self.layer.cornerRadius = 6.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProfile)))
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProfile)))
        
        // Add subviews and constraints
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(bodyTextView)
        addSubview(postImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: bodyTextView)
        addConstraintsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        
        if (post?.hasImage)! {
            addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]|", views: profileImageView, bodyTextView, postImageView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: postImageView)
        }
        else {
            addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]|", views: profileImageView, bodyTextView)
        }
        
    }
}



