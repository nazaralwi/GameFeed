import UIKit

final class NewGameViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
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
        navigationController?.navigationBar.barStyle = .black
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            detail?.game = games[selectedIndex]
        }
    }

    private func setupView() {
        let now = Date()
        let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: now)

        errorLabel.isHidden = true
        loadingIndicator.startAnimating()

        viewModel?.fetchNewGame(
            lastMonth: Formatter.formatDateToString(from: oneMonthBefore ?? Date()),
            now: Formatter.formatDateToString(from: now))

        tableView.dataSource = self
        tableView.delegate = self

        viewModel?.delegate = self

        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
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
            cell.ratingGame.text = game.rating

            if let downloadedImage = game.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if game.backgroundImage != nil {
                viewModel!.fetchBackground(for: game)
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
        performSegue(withIdentifier: "showDetail", sender: nil)
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
