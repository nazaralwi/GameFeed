import UIKit

final class MyProfileViewController: UIViewController {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myphoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private lazy var editProfileButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editProfileTapped)
        )
        return button
    }()

    var viewModel: MyProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        navigationItem.rightBarButtonItem = editProfileButton
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

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

    private func setupView() {
        [profileImageView, nameLabel, companyLabel, emailLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),

            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            companyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            companyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }

    @objc private func editProfileTapped() {
        let updateVC = UpdateViewController()
        updateVC.viewModel = viewModel
        navigationController?.pushViewController(updateVC, animated: true)
    }
}
