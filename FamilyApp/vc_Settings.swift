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
        
        if (let val = UserDefaults.standard.bool(forKey: "settingOne")) {
            switchOne.isOn = val
        } else {
            switchOne.isOn = true
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
        
        print(switchOne.isOn)
    }
    
    
    
}
