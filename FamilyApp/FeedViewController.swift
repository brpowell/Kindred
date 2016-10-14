//
//  FeedViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

let cellId = "cellId"

class Post {
    var key: String?
    var name: String?
    var profile: UIImage?
    var body: String?
    var timestamp: TimeInterval?
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.name = snapshotValue["author"] as? String
        self.body = snapshotValue["body"] as? String
        self.timestamp = snapshotValue["timestamp"] as? TimeInterval
    }
}

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable, SlideMenuControllerDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    let postsRef = FIRDatabase.database().reference(withPath: "posts")
    var posts = [Post]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenuController()?.delegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateDates), userInfo: nil, repeats: true)
        
        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        self.startAnimating()
        
        // Feed listener to get posts from Firebase
        postsRef.observe(.value, with: { snapshot in
            var newPosts: [Post] = []
            
            for post in snapshot.children {
                let post = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(post)
            }
            
            self.posts = newPosts.reversed()
            self.collectionView?.reloadData()
            self.stopAnimating()
        })
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // Enable/disable scrolling depending on drawer state
    func leftWillOpen() {
        collectionView?.isScrollEnabled = false
    }
    func leftDidClose() {
        collectionView?.isScrollEnabled = true
    }
    
    func updateDates() {
        for cell in collectionView?.visibleCells as! [FeedCell] {
            cell.loadNameLabel()
        }
    }
    
    // Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Create cell for post
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.post = posts[indexPath.item]
        return feedCell
    }
    
    // Calculate size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let bodyText = posts[indexPath.item].body {
            let rect = NSString(string: bodyText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 40)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // Trigger left drawer on menu button
    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    // Segue to post screen
    @IBAction func onComposeButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "postSegue", sender: sender)
    }
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {}
}

// Cell class to define layout of content
class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            if ((post?.name) != nil) {
                loadNameLabel()
            }
            
            if let body = post?.body {
                bodyTextView.text = body
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
        imageView.image = UIImage(named: "profile")
        
        imageView.layer.cornerRadius = 22
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

// Constraints helper extension
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 minute ago"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!) seconds ago"
        } else {
            result = "Just now"
        }
        
        return result
    }
}
