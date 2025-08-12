import UIKit

final class FavoritesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyImage: UIImageView!

    var viewModel: FavoritesViewModel?

    private var games = [GameUIModel]()
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .black

        UITabBar.appearance().standardAppearance = tabBarAppearance
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            let id = Int(games[selectedIndex].idGame)
            detail?.game = games[selectedIndex]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func loadFavorites() {
        self.viewModel?.fetchUsers()
    }

    private func setupView() {
        self.tableView.contentInset.bottom = 10

        tableView.dataSource = self
        tableView.delegate = self

        viewModel?.delegate = self

        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    private func favoriteIsEmpty(state: Bool) {
        if state {
            emptyLabel.isHidden = true
            emptyImage.isHidden = true
        } else {
            emptyLabel.isHidden = false
            emptyImage.isHidden = false
        }
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
            cell.genreGame.text = favorite.genres

            if let downloadedImage = favorite.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if favorite.backgroundImage != nil {
                viewModel!.fetchBackground(for: favorite)
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
        performSegue(withIdentifier: "showDetail", sender: nil)
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
