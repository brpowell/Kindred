//
//  FamilyViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/11/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController {

    @IBOutlet weak var contactsBarButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBar.selectedItem = contactsBarButton
        tabBar.tintColor = UIColor(red:0.72, green:0.91, blue:0.53, alpha:1.0)
        tabBar.unselectedItemTintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMenuButton(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }

}
