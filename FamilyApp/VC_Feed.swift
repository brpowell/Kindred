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
    
    override func viewDidAppear(_ animated: Bool) {
        self.slideMenuController()?.removeRightGestures()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blackBackgroundView.minimumZoomScale = 1.0
        self.blackBackgroundView.maximumZoomScale = 6.0
        blackBackgroundView.delegate = self
        
        // Image rotation listener
//        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        LoginViewController.listener = true
        self.slideMenuController()?.delegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateDates), userInfo: nil, repeats: true)
        
        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        self.startAnimating()
        
        // Add padding to edges
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let ref = FIRDatabase.database().reference(withPath: "contacts").child(Database.user.uid)
        let ownName = Database.user.firstName + " " + Database.user.lastName
        var contacts: [String] = [ownName]
        ref.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                let snapshot = snap as! FIRDataSnapshot
                let snapshotValue = snapshot.value as! [String: AnyObject]
                if let name = snapshotValue["name"] as? String {
                    contacts.append(name)
                }
            }
            // Feed listener to get posts from Firebase
            self.postsRef.observe(.value, with: { snapshot in
                var newPosts: [Post] = []
                var profilesToDownload: [String] = []
                
                for post in snapshot.children {
                    let post = Post(snapshot: post as! FIRDataSnapshot)
                    if !contacts.contains(post.name!) {
                        continue
                    }
                    let uid = post.uid
                    
                    if let profileImage = self.profileCache[uid!] {
                        post.profile = profileImage
                    }
                    else {
                        profilesToDownload.append(uid!)
                    }
                    
                    newPosts.append(post)
                }
                
                self.posts = newPosts.reversed()
                self.collectionView?.reloadData()
                self.stopAnimating()
            })

        })
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        print(Database.userCache)
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
        
        // Load cell content and set feed controller
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        
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
            
            return CGSize(width: view.frame.width - 20, height: rect.height + knownHeight + 36)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    // Image zooming
    let blackBackgroundView = UIScrollView()
    var postImageView: UIImageView?
    let zoomImageView = UIImageView()
    let navBarCoverView = UIView()
    var zoomEnabled = false
//    let scrollView = UIScrollView()
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView
    }
    
    func animateImageView(postImageView: UIImageView) {
        self.postImageView = postImageView
        if let startingFrame = postImageView.superview?.convert(postImageView.frame, to: nil) {
            postImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            
            zoomImageView.backgroundColor = UIColor.black
            zoomImageView.frame = blackBackgroundView.frame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = postImageView.image
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.clipsToBounds = true
            
            blackBackgroundView.addSubview(zoomImageView)

            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(blackBackgroundView)
            }
            
            zoomEnabled = true
            
            blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
            }, completion: nil)

        }
    }
    
    func zoomOut() {
        if let startingFrame = postImageView!.superview?.convert(postImageView!.frame, to: nil) {

            UIView.animate(withDuration: 0.25, animations: {
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.postImageView?.alpha = 1
                self.navBarCoverView.removeFromSuperview()
                self.zoomEnabled = false
            })
        }
    }
    
    // Landscape/portrait handler when zoomed on image
    func rotated() {
        if UIDevice.current.orientation.isLandscape && zoomEnabled {
            print("Rotate")
            UIView.animate(withDuration: 0.25, animations: {
                self.zoomImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/2))
            })
        } else {
            // Portrait
        }
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
