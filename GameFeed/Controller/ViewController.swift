import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    var gameViewModel: HomeViewModel?

    var selectedIndex = 0

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            detail?.gameId = gameViewModel!.games[selectedIndex].idGame
            detail?.game = gameViewModel!.games[selectedIndex]
        }
    }

    func setupView() {
        self.gameTableView.contentInset.bottom = 10

        gameTableView.dataSource = self
        gameTableView.delegate = self

        gameViewModel?.delegate = self

        gameTableView.refreshControl = UIRefreshControl()
        gameTableView.refreshControl?.tintColor = UIColor.gray
        gameTableView.refreshControl?.addTarget(
            self,
            action: #selector(fetchGameList),
            for: UIControl.Event.valueChanged)

        errorLabel.isHidden = true

        loadGameList()

        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    private func loadGameList() {
        gameViewModel?.fetchUsers()
    }

    @objc func fetchGameList() {
        gameViewModel?.fetchUsers()

        DispatchQueue.main.async {
           self.gameTableView.refreshControl?.endRefreshing()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameViewModel!.games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = gameViewModel!.games[indexPath.row]

            cell.releaseGame.text = game.released
            cell.genreGame.text = game.genres
            cell.titleGame.text = game.name
            cell.ratingGame.text = game.rating

            if let downloadedImage = game.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if let backgroundPath = game.backgroundImage {
                gameViewModel!.fetchBackground(for: game)
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: HomeViewModelDelegate {
    func didUpdateGames() {
        self.gameTableView.reloadData()
    }
    
    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
