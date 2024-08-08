import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!

    public var viewModel: HomeViewModel?

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
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            detail?.game = games[selectedIndex]
        }
    }

    private func setupView() {
        self.tableView.contentInset.bottom = 10

        tableView.dataSource = self
        tableView.delegate = self

        viewModel?.delegate = self

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.gray
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(fetchGameList),
            for: UIControl.Event.valueChanged)

        errorLabel.isHidden = true

        loadGameList()

        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    private func loadGameList() {
        viewModel?.fetchGames()
    }

    @objc private func fetchGameList() {
        viewModel?.fetchGames()

        DispatchQueue.main.async {
           self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = games[indexPath.row]

            cell.releaseGame.text = game.released
            cell.genreGame.text = game.genres
            cell.titleGame.text = game.name
            cell.ratingGame.text = game.rating

            if let downloadedImage = game.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if game.backgroundImage != nil {
                viewModel!.fetchBackground(for: game)
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
