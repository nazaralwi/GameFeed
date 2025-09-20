import UIKit

final class UpdateViewController: UIViewController {
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myphoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()

    let companyLabel: UILabel = {
        let label = UILabel()
        label.text = "Company"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    let companyTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .emailAddress
        return textField
    }()

    var viewModel: MyProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        [photoImageView,
         nameLabel, nameTextField,
         companyLabel, companyTextField,
         emailLabel, emailTextField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // Photto
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Name
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            // Company
            companyLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            companyLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),

            companyTextField.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8),
            companyTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            companyTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            companyTextField.heightAnchor.constraint(equalToConstant: 44),

            // Email
            emailLabel.topAnchor.constraint(equalTo: companyTextField.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ])

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveProfile)
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
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

    @objc private func saveProfile(_ sender: Any) {
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
