import UIKit

class UpdateViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    var profileViewModel: MyProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
    }

    func updateUI() {
        nameTextField.text = profileViewModel!.name
        companyTextField.text = profileViewModel!.company
        emailTextField.text = profileViewModel!.email
    }

    @IBAction func saveProfile(_ sender: Any) {
        if let name = nameTextField.text, let company = companyTextField.text, let email = emailTextField.text {
            if profileViewModel!.saveProfile(name: name, company: company, email: email) {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            } else {
                showAlert(for: "Name, Company, or Email")
            }
        }
    }

    func showAlert(for field: String) {
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
