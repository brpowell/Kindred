//
//  ProfileActivityViewController.swift
//  
//
//  Created by Apurva Gorti on 10/31/16.
//
//

import UIKit
import Firebase

class ProfileActivityViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add padding to edges
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let ref = FIRDatabase.database().reference(withPath: "posts")
            // Feed listener to get posts from Firebase
        let name = (OtherProfileViewController.user?.firstName)! + " " + (OtherProfileViewController.user?.lastName)!
        ref.queryOrdered(byChild: "author").queryEqual(toValue: name).observeSingleEvent(of: .value, with: { snapshot in
                var newPosts: [Post] = []
            
                for post in snapshot.children {
                    let post = Post(snapshot: post as! FIRDataSnapshot)
                    
                    newPosts.append(post)
                }
                print(newPosts)
                self.posts = newPosts.reversed()
                self.collectionView?.reloadData()
        })
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
