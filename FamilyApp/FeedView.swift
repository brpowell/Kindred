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
            
            let uid = (post?.uid)!
            
            // Load the profile image
            if let image = Database.profileImageCache.object(forKey: NSString(string: uid)) {
                profileImageView.image = image
            }
            else {
                let profileImageRef = Database.profileImagesRef.child(uid)
                profileImageRef.data(withMaxSize: 1024*1024) { data, error in
                    if error != nil {
                        print(error)
                    }
                    else {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            let key: NSString = NSString(string: uid)
                            Database.profileImageCache.setObject(image!, forKey: key)
                            self.profileImageView.image = image
                        }
                    }
                }
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
                            print(error)
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
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
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
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = UIColor.black
        
        imageView.layer.cornerRadius = 22
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        return imageView
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        
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



