import UIKit

final class MyProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    var viewModel: MyProfileViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel!.synchronize()
        updateUI()
    }

    private func updateUI() {
        let devProfile = viewModel!.getProfile()

        nameLabel.text = devProfile.name
        companyLabel.text = devProfile.company
        emailLabel.text = devProfile.email
    }
}
