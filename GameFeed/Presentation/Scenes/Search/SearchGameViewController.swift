import UIKit

final class SearchGameViewController: UIViewController {
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private let searchBar = UISearchBar()

    public var viewModel: SearchGameViewModel?

    private var games: [GameUIModel] = []
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "Search Game"

        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .black

        UITabBar.appearance().standardAppearance = tabBarAppearance

        searchBar.becomeFirstResponder()
    }

    private func setupView() {
        [tableView, searchBar, loadingIndicator, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        viewModel?.delegate = self

        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 360
        tableView.backgroundColor = .systemGroupedBackground
    }
}

extension SearchGameViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchGames(query: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]

            cell.releaseGame.text = game.released
            cell.genreGame.text = game.genres
            cell.titleGame.text = game.name
            cell.ratingGame.text = "⭐️ " + game.rating

            if let downloadedImage = game.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else {
                if game.backgroundImagePath != "broken_image" {
                    viewModel!.fetchBackground(for: game)
                } else {
                    cell.photoGame.image = UIImage(systemName: "photo.badge.exclamationmark")
                }
            }

            cell.setNeedsLayout()
            cell.photoGame.roundCorners(corners: [.topRight, .topLeft], radius: 10)

            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension SearchGameViewController: UITableViewDelegate {
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

extension SearchGameViewController: SearchGameViewModelDelegate {
    func didUpdateGames() {
        self.games = viewModel!.games
        self.tableView.reloadData()
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
