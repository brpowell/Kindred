//
//  OtherProfileViewController.swift
//  FamilyApp
//
//  Created by Bryan Powell on 10/20/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    static var user: User?
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    
    var activityViewController: UIViewController!
    var contactsViewController: UIViewController!
    var infoViewController: UIViewController!
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = OtherProfileViewController.user
        
        if let firstName = user?.firstName {
            if let lastName = user?.lastName {
                nameLabel.text = firstName + " " + lastName
            }
        }
        
        if let image = user?.photo {
            userProfileImage.makeProfileFormat()
            userProfileImage.image = image
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        activityViewController = storyboard.instantiateViewController(withIdentifier: "ProfileActivityViewController")
        contactsViewController = storyboard.instantiateViewController(withIdentifier: "ProfileContactsViewController")
        infoViewController = storyboard.instantiateViewController(withIdentifier: "ProfileInfoViewController")
        
        viewControllers = [activityViewController, contactsViewController, infoViewController]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popoverViewController = segue.destination as! RelationPopoverViewController
        let controller = popoverViewController.popoverPresentationController
        
        controller!.delegate = self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
}
