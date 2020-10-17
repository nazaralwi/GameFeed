import UIKit
import MessageUI

class MyProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.synchronize()
        nameLabel.text = ProfileModel.name
        companyLabel.text = ProfileModel.company
        emailLabel.text = ProfileModel.email
    }
    
    @IBAction func editProfile(_ sender: Any) {
//        let mailComposeViewController = configureMailComposer()
//        if MFMailComposeViewController.canSendMail() {
//           self.present(mailComposeViewController, animated: true, completion: nil)
//        } else {
//           print("Can't send email")
//        }
        self.performSegue(withIdentifier: "moveToUpdate", sender: self)
    }
    
    @IBAction func resetProfile(_ sender: Any) {
        if ProfileModel.deleteAll() {
            self.performSegue(withIdentifier: "moveToCreate", sender: self)
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
