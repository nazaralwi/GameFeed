import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet var favoriteTableView: UITableView!
    private var favorites = [GameUIModel]()
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var emptyImage: UIImageView!
    var selectedIndex = 0
    
    var favoritesViewModel: FavoritesViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            let id = Int(favorites[selectedIndex].idGame)
            detail?.gameId = id
            detail?.game = favorites[selectedIndex]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func loadFavorites() {
        self.favoritesViewModel?.fetchUsers()
    }

    func setupView() {
        self.favoriteTableView.contentInset.bottom = 10

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self

        favoritesViewModel?.delegate = self

        favoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    func favoriteIsEmpty(state: Bool) {
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
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let favorite = favorites[indexPath.row]

            cell.titleGame.text = favorite.name
            cell.ratingGame.text = favorite.rating
            cell.releaseGame.text = favorite.released
            cell.genreGame.text = favorite.genres

            if let downloadedImage = favorite.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if let backgroundPath = favorite.backgroundImage {
                favoritesViewModel!.fetchBackground(for: favorite)
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
        self.favorites = favoritesViewModel!.games
        self.favoriteTableView.reloadData()
        favoriteIsEmpty(state: !self.favorites.isEmpty)
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {

    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
