import UIKit

final class FavoritesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 360
        tableView.backgroundColor = .systemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
        return tableView
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "tray.fill")
        imageView.tintColor = .lightGray
        imageView.isHidden = true
        return imageView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.text = "Favorite is empty"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    var viewModel: FavoritesViewModel?

    private var games = [GameUIModel]()
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        viewModel?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func loadFavorites() {
        self.viewModel?.fetchUsers()
    }

    private func setupView() {
        [tableView, loadingIndicator, errorLabel, emptyImage, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImage.heightAnchor.constraint(equalToConstant: 150),
            emptyImage.widthAnchor.constraint(equalToConstant: 150),

            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyImage.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyImage.trailingAnchor)
        ])
    }

    private func favoriteIsEmpty(state: Bool) {
        emptyLabel.isHidden = state
        emptyImage.isHidden = state
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let favorite = games[indexPath.row]

            cell.titleGame.text = favorite.name
            cell.ratingGame.text = favorite.rating
            cell.releaseGame.text = favorite.released
            cell.genreGame.text = "⭐️ " + favorite.rating

            if let downloadedImage = favorite.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else {
                if favorite.backgroundImagePath != "broken_image" {
                    viewModel!.fetchBackground(for: favorite)
                } else {
                    cell.photoGame.image = UIImage(systemName: "photo.badge.exclamationmark")
                }
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        let container = SwinjectContainer.getContainer()

        let detailVC = DetailGameViewController()
        detailVC.viewModel = container.resolve(DetailViewModel.self)
        detailVC.game = games[selectedIndex]

        navigationController?.pushViewController(detailVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func didUpdateGames() {
        self.games = viewModel!.games
        self.tableView.reloadData()
        favoriteIsEmpty(state: !self.games.isEmpty)
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
