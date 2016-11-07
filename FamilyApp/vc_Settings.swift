//
//  SettingsViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 11/3/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var switchThree: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerView.layer.borderColor = FAColor.green.cgColor
        containerView.layer.borderWidth = 2.0
        containerView.layer.cornerRadius = 6.0
        
        if (UserDefaults.standard.object(forKey: "settingOne") != nil) {
            self.switchOne.isOn = UserDefaults.standard.bool(forKey: "settingOne")
        } else {
            self.switchOne.isOn = true
        }
        
        if (UserDefaults.standard.object(forKey: "settingTwo") != nil) {
            self.switchTwo.isOn = UserDefaults.standard.bool(forKey: "settingTwo")
        } else {
            self.switchTwo.isOn = true
        }
        
        if (UserDefaults.standard.object(forKey: "settingThree") != nil) {
            self.switchThree.isOn = UserDefaults.standard.bool(forKey: "settingThree")
        } else {
            self.switchThree.isOn = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMenuButton(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func changeSwitchOne(_ sender: AnyObject) {
        if (switchOne.isOn) {
            UserDefaults.standard.set(true, forKey: "settingOne")
        } else {
            UserDefaults.standard.set(false, forKey: "settingOne")
        }
    }
    
    @IBAction func changeSwitchTwo(_ sender: AnyObject) {
        if (switchTwo.isOn) {
            UserDefaults.standard.set(true, forKey: "settingTwo")
        } else {
            UserDefaults.standard.set(false, forKey: "settingTwo")
        }
    }
    
    @IBAction func changeSwitchThree(_ sender: AnyObject) {
        if (switchThree.isOn) {
            UserDefaults.standard.set(true, forKey: "settingThree")
        } else {
            UserDefaults.standard.set(false, forKey: "settingThree")
        }
    }
    
}
