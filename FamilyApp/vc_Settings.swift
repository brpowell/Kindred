//
//  SettingsViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 11/3/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var switchThree: UISwitch!
    let ref = FIRDatabase.database().reference(withPath: "settings").child(Database.user.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerView.layer.borderColor = FAColor.green.cgColor
        containerView.layer.borderWidth = 2.0
        containerView.layer.cornerRadius = 6.0
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                let settings = Settings(snapshot: snapshot)
                self.switchOne.isOn = settings.settingOne!
                self.switchTwo.isOn = settings.settingTwo!
                self.switchThree.isOn = settings.settingThree!
                
            } else {
                self.switchOne.isOn = true
                self.switchTwo.isOn = true
                self.switchThree.isOn = true
                Database.db.createSettings()
            }
        })
        
        
        
//        if (UserDefaults.standard.object(forKey: "settingOne") != nil) {
//            self.switchOne.isOn = UserDefaults.standard.bool(forKey: "settingOne")
//        } else {
//            self.switchOne.isOn = true
//        }
//        UserDefaults.standard.set(false, forKey: "settingThree")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onMenuButton(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func changeSwitchOne(_ sender: AnyObject) {
        if (switchOne.isOn) {
            ref.updateChildValues(["settingOne": true])
        } else {
            ref.updateChildValues(["settingOne": false])
        }
    }
    
    @IBAction func changeSwitchTwo(_ sender: AnyObject) {
        if (switchTwo.isOn) {
            ref.updateChildValues(["settingTwo": true])
        } else {
            ref.updateChildValues(["settingTwo": false])
        }
    }
    
    @IBAction func changeSwitchThree(_ sender: AnyObject) {
        if (switchThree.isOn) {
            ref.updateChildValues(["settingThree": true])
        } else {
            ref.updateChildValues(["settingThree": false])
        }
    }
    
}
