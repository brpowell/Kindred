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
    
    var keyboardHeight: CGFloat = 0.0
    let imagePicker = UIImagePickerController()
    
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
            let time = FIRServerValue.timestamp()
            let user = FIRAuth.auth()?.currentUser
            let key = postsRef.childByAutoId().key

            let data = [
                "uid": (user?.uid)!,
                "author": (user?.displayName)!,
                "body": postBody,
                "timestamp": time] as [String : Any]
            
            postsRef.child("\(key)").setValue(data)
            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        }
    }

    @IBAction func onAddPhoto(_ sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onTakePhoto(_ sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //            profileImage.contentMode = .scaleAspectFit
//            profileImage.image = pickedImage
            print("Image Set")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
