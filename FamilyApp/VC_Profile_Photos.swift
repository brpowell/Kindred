//
//  VC_Profile_Photos.swift
//  FamilyApp
//
//  Created by Bryan Powell on 11/28/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "photoCell"

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}

class ProfilePhotosViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        photosCollectionView.dataSource = self
        fetchImages()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    
    func fetchImages() {
        
        let ref = FIRDatabase.database().reference(withPath: "posts")
        // Feed listener to get posts from Firebase
        let name = (OtherProfileViewController.user?.firstName)! + " " + (OtherProfileViewController.user?.lastName)!
        ref.queryOrdered(byChild: "author").queryEqual(toValue: name).observeSingleEvent(of: .value, with: { snapshot in
            
            for post in snapshot.children {
                let post = Post(snapshot: post as! FIRDataSnapshot)
                if post.hasImage! {
                    let imageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/postImages/" + post.key!)
                    imageRef.data(withMaxSize: 1024*1024) { (data, error) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            let photo = UIImage(data: data!)
                            self.photos.append(photo!)
                            self.photosCollectionView.reloadData()
                        }
                    }
                }
            }
            
        })
    }
    
}
