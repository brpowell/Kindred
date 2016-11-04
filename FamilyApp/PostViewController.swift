//
//  PostViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/12/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: InputViewController, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPickerViewDelegate {

    @IBOutlet weak var postView: PlaceholderUITextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var keyboardHeight: CGFloat = 0.0
    let imagePicker = UIImagePickerController()
    var postImage: UIImage?
    
    let postsRef = FIRDatabase.database().reference(withPath:
    "posts")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // Bottom height constraint value is based on whether keyboard is showing
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                // bottomHeight matches keyboard height
//                bottomHeight?.constant = keyboardSize.height
                bottom?.constant = keyboardSize.height
                keyboardHeight = keyboardSize.height
                view.setNeedsLayout()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        // No keyboard, so bottomHeight back to 0
        bottom?.constant = (bottom?.constant)! - keyboardHeight
        view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        postButton.isEnabled = false
        postView.buttonToControl = postButton
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        if postView.labelPlaceholder.isHidden {
            let message = "Are you sure you want to discard this post?"
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in

            }
            alertController.addAction(cancelAction)
            
            let destroyAction = UIAlertAction(title: "Discard", style: .destructive) { (action) in
                self.performSegue(withIdentifier: "unwindToFeed", sender: self)
            }
            alertController.addAction(destroyAction)
            
            self.present(alertController, animated: true)
        }
        else {
            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postView.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func onPostButton(_ sender: AnyObject) {
        if let postBody = postView.textView.text {
            postButton.isEnabled = false
            
            let time = FIRServerValue.timestamp()
            let user = FIRAuth.auth()?.currentUser
            let key = postsRef.childByAutoId().key

            var data = [
                "uid": (user?.uid)!,
                "author": (user?.displayName)!,
                "body": postBody,
                "timestamp": time,
                "image": false] as [String : Any]
            
            if let image = postImage {
                let postImageRef = Database.postImagesRef.child(key)
                let imageData = image.jpegData(quality: .medium)
                postImageRef.put(imageData!, metadata: nil) { metadata, error in
                    
                    if error != nil {
                        print(error)
                        self.postButton.isEnabled = true
                    }
                    else {
                        data["hasImage"] = true
                        self.postsRef.child("\(key)").setValue(data)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
                        }
                    }
                }
            }
            else {
                postsRef.child("\(key)").setValue(data)
                self.performSegue(withIdentifier: "unwindToFeed", sender: self)
            }
        }
    }

    @IBAction func onAddPhoto(_ sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onTakePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
