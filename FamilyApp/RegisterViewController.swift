//
//  RegisterViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/9/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView

class RegisterViewController: InputViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var lastTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var email = String()
    var password = String()
    let ref = FIRDatabase.database().reference(withPath: "users")
    let imagePicker = UIImagePickerController()
    
    static var listener:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        
        RegisterViewController.listener = true
        LoginViewController.listener = true
        imagePicker.delegate = self
//        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
//        profileImage.clipsToBounds = true
//        profileImage.layer.borderWidth = 3.0
//        profileImage.layer.borderColor = UIColor.white.cgColor
        
        // Firebase Auth Listener
//        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
//            if user != nil && RegisterViewController.listener {
//                RegisterViewController.listener = false
//                let first = self.firstTextField.text!
//                let last = self.lastTextField.text!
//                let u = User(authData: user!, firstName: first, lastName: last, birthday: self.birthdayTextField.text!)
//                
//                let userRef = self.ref.child(u.uid)
//                userRef.setValue(u.toAnyObject())
//                
//                let changeRequest = user?.profileChangeRequest()
//                changeRequest?.displayName = first + " " + last
//                
//                User.activeUserImage = self.profileImage.image!
//                
//                changeRequest?.commitChanges { error in
//                    if let error = error {
//                        print(error)
//                    } else {
//                        // Profile updated
//                        self.performSegue(withIdentifier: "registerHomeSegue", sender: nil)
//                    }
//                }
//            } else {
//                // No user is signed in.
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func birthdayEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func onRegisterDone(_ sender: AnyObject) {
        if firstTextField.text != "" && lastTextField.text != "" && birthdayTextField.text != "" {
            self.startAnimating()
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                let uid = user?.uid
                let profileImageRef = FIRStorage.storage().reference(forURL: "gs://familyapp-e0bae.appspot.com/profileImages/"+uid!)
                let data = self.profileImage.image?.jpegData(quality: .low)
                _ = profileImageRef.put(data!, metadata: nil) { metadata, error in
                    if error != nil {
                        print(error)
                    }
                    else {
                        let first = self.firstTextField.text!
                        let last = self.lastTextField.text!
                        let u = User(authData: user!, firstName: first, lastName: last, birthday: self.birthdayTextField.text!)
                        
                        let userRef = self.ref.child(u.uid)
                        userRef.setValue(u.toAnyObject())
                        
                        let changeRequest = user?.profileChangeRequest()
                        changeRequest?.displayName = first + " " + last
                        changeRequest?.photoURL = metadata!.downloadURL()
                        
                        User.activeUserImage = self.profileImage.image!
                        
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                print(error)
                            } else {
                                // Profile updated
                                self.stopAnimating()
                                self.performSegue(withIdentifier: "registerHomeSegue", sender: nil)
                            }
                        }
                    }
                }
            });

        }
    }

    @IBAction func onImageButton(_ sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onBackbutton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    var pngData: Data? { return UIImagePNGRepresentation(self) }
    
    func jpegData(quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
