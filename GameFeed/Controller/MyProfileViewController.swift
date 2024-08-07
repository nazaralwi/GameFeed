import UIKit

class MyProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    var myProfileViewModel: MyProfileViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myProfileViewModel?.synchronize()
        updateUI()
    }

    func updateUI() {
        nameLabel.text = myProfileViewModel!.name
        companyLabel.text = myProfileViewModel!.company
        emailLabel.text = myProfileViewModel!.email
    }
}
