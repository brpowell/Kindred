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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerView.layer.borderColor = FAColor.green.cgColor
        containerView.layer.borderWidth = 2.0
        containerView.layer.cornerRadius = 6.0
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
}
