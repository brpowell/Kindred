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

class RegisterViewController: InputViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstField: FATextField!
    @IBOutlet weak var lastField: FATextField!
    @IBOutlet weak var birthdayField: FATextField!
    @IBOutlet weak var genderField: FATextField!
    
    var email = String()
    var password = String()
    let ref = FIRDatabase.database().reference(withPath: "users")
    let imagePicker = UIImagePickerController()
    var profileImageSet = false
    
    let genders = ["Female", "Male", "Other"]
    
    static var listener:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Activity loader
        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 1000
        
        RegisterViewController.listener = true
        LoginViewController.listener = true
        imagePicker.delegate = self
        profileImage.makeProfileFormat()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderField.textField.inputView = pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.textField.text = genders[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRegisterDone(_ sender: AnyObject) {
        if fieldCheck() {
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
                        let first = self.firstField.textField.text!
                        let last = self.lastField.textField.text!
                        let gen = self.genderField.textField.text!
                        let u = User(authData: user!, firstName: first, lastName: last, birthday: self.birthdayField.textField.text!, gender: gen)
                        
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
                                Database.user = u
                                self.performSegue(withIdentifier: "registerHomeSegue", sender: nil)
                            }
                            self.stopAnimating()
                        }
                    }
                }
            });

        }
    }
    
    // Validate text fields
    func fieldCheck() -> Bool {
        var title = "Missing Fields"
        var message = "Please fill in all of the profile fields"
        
        if firstField.textField.text != "" && lastField.textField.text != "" && birthdayField.textField.text != "" && genderField.textField.text != "" {
            if profileImageSet {
                return true
            }
            title = "No Photo"
            message = "Please select a photo for your profile picture"
        }
        
        Alerts.okError(title: title, message: message, viewController: self)
        
        return false
    }
    
    // Add profile picture
    @IBAction func onImageButton(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Photo library option
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(libraryAction)
        
        // Camera option
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
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
        alertController.addAction(cameraAction)
        
        self.present(alertController, animated: true)
    }
    
    @IBAction func onBackbutton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = pickedImage
            self.profileImageSet = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}





