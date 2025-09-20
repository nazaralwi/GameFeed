import UIKit

final class NewGameViewController: UIViewController {
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    var viewModel: NewGameViewModel?

    private var games: [GameUIModel] = []
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .black

        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

    private func setupView() {
        [tableView, loadingIndicator, errorLabel].forEach {
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
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let now = Date()
        let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: now)

        errorLabel.isHidden = true
        loadingIndicator.startAnimating()

        viewModel?.fetchNewGame(
            lastMonth: Formatter.formatDate(from: oneMonthBefore ?? Date()),
            now: Formatter.formatDate(from: now))

        tableView.dataSource = self
        tableView.delegate = self

        viewModel?.delegate = self

        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 360
        tableView.backgroundColor = .systemGroupedBackground
    }
}

extension NewGameViewController: UITableViewDataSource {
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

extension NewGameViewController: UITableViewDelegate {
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

extension NewGameViewController: NewGameViewModelDelegate {
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
