import UIKit

final class UpdateViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    var viewModel: MyProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.onChange = { [weak self] data in
            DispatchQueue.main.async {
                self?.nameTextField.text = data.name
                self?.companyTextField.text = data.company
                self?.emailTextField.text = data.email
            }
        }

        viewModel?.load()
    }

    @IBAction func saveProfile(_ sender: Any) {
        if let name = nameTextField.text, let company = companyTextField.text, let email = emailTextField.text {
            if viewModel!.save(name: name, company: company, email: email) {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            } else {
                showAlert(for: "Name, Company, or Email")
            }
        }
    }

    private func showAlert(for field: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: "\(field) is empty",
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
