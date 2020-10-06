//
//  MyProfileViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 04/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import MessageUI

class MyProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
           self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
           print("Can't send email")
        }
    }
    
    func configureMailComposer() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["alwinazar75@gmail.com"])
        mailComposeVC.setSubject("Review Your Code")
        mailComposeVC.setMessageBody("Hi, Nazar", isHTML: false)
        return mailComposeVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
