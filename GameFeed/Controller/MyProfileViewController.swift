import UIKit
import MessageUI

class MyProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !ProfileModel.stateEdit {
            saveExistingData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.synchronize()
        nameLabel.text = ProfileModel.name
        companyLabel.text = ProfileModel.company
        emailLabel.text = ProfileModel.email
    }

    func saveExistingData() {
        if let name = nameLabel.text, let company = companyLabel.text, let email = emailLabel.text {
            saveProfile(name, company, email)
        }
    }

    func saveProfile(_ name: String, _ company: String, _ email: String) {
        ProfileModel.name = name
        ProfileModel.company = company
        ProfileModel.email = email
    }
}
