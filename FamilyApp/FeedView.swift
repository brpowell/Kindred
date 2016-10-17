//
//  FeedView.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/14/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
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
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
        return textView
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(bodyTextView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]|", views: profileImageView, bodyTextView)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: bodyTextView)
    }
}



