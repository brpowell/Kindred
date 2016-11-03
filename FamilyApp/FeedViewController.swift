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

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable, SlideMenuControllerDelegate {
    
    var profileCache:[String: UIImage] = [:]

    @IBOutlet weak var welcomeLabel: UILabel!
    
    let postsRef = FIRDatabase.database().reference(withPath: "posts")
    var posts = [Post]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        LoginViewController.listener = true
        //self.slideMenuController()?.delegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateDates), userInfo: nil, repeats: true)
        
        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        self.startAnimating()

        // Feed listener to get posts from Firebase
        postsRef.observe(.value, with: { snapshot in
            var newPosts: [Post] = []
            var profilesToDownload: [String] = []
            
            for post in snapshot.children {
                let post = Post(snapshot: post as! FIRDataSnapshot)
                let uid = post.uid
                
                if let profileImage = self.profileCache[uid!] {
                    post.profile = profileImage
                }
                else {
                    profilesToDownload.append(uid!)
                }
                
                newPosts.append(post)
            }

//            let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/" + uid!)
//            profileImageRef.data(withMaxSize: 1024*1024) { (data, error) in
//                if error != nil {
//                    //                          print(error)
//                }
//                else {
//                    self.profileCache[uid!] = UIImage(data: data!)
//                }
//            }
            
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
        
        // Clean cell content
        feedCell.bodyTextView.text = nil
        feedCell.postImageView.image = nil
        feedCell.nameLabel.text = nil
        feedCell.profileImageView.image = nil
        
        // Load cell content
        feedCell.post = posts[indexPath.item]
        
        return feedCell
    }
    
    // Calculate size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let bodyText = posts[indexPath.item].body {
            let rect = NSString(string: bodyText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            // 8: profileImage, 44: bodyText
            // Add 200 if post has an image
            var knownHeight: CGFloat = 8 + 44 + 4
            if posts[indexPath.item].hasImage! {
                knownHeight += 4 + 200
            }
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 36)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {}
    
    // Trigger left drawer on menu button
    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    // Segue to post screen
    @IBAction func onComposeButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "postSegue", sender: sender)
    }

}
