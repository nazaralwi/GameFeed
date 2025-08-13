import UIKit

final class MyProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    var viewModel: MyProfileViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.onChange = { [weak self] data in
            DispatchQueue.main.async {
                self?.nameLabel.text = data.name
                self?.companyLabel.text = data.company
                self?.emailLabel.text = data.email
            }
        }

        viewModel?.load()
    }
}
