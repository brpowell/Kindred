//
//  Database.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/17/16.
//  Copyright © 2016 uab. All rights reserved.
//

import Foundation
import Firebase

class Database {
    static let db = Database()
    
    var name: String?
    var email: String?
    var photoUrl: URL?
    var uid: String?
    var ref: FIRDatabaseReference!
    
    var birthday: String?
    var firstName: String?
    var lastName: String?
 
    private init() {
        if let user = FIRAuth.auth()?.currentUser {
            name = user.displayName!
            email = user.email!
            photoUrl = user.photoURL!
            uid = user.uid

            print(uid)
            
            //Query user from Firebase DB
            
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.firstName = value?["firstName"] as! String
                self.birthday = value?["birthday"] as! String
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        
//            ref = FIRDatabase.database().reference()
//            let userQuery = ref.child("users").child(uid!)
//            self.birthday = userQuery.value(forKey: "birthday") as? String
//            self.firstName = userQuery.value(forKey: "firstName") as? String
//            self.lastName = userQuery.value(forKey: "lastName") as? String
            
            
        } else {
            print("FAILED AUTHENTICATION")
        }
    }
    
    func getName() {
        print("HERE")
    }
}
