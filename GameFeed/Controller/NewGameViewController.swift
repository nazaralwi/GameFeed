import UIKit

class NewGameViewController: UIViewController {
    @IBOutlet var newGameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    var newGameViewModel: NewGameViewModel?

    var selectedIndex = 0
    var newGame = [GameUIModel]()

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
            detail?.gameId = newGame[selectedIndex].idGame
        }
    }

    func setupView() {
        let now = Date()
        let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: now)

        errorLabel.isHidden = true
        activityIndicator.startAnimating()

        newGameViewModel?.fetchNewGame(
            lastMonth: Formatter.formatDateToString(from: oneMonthBefore ?? Date()),
            now: Formatter.formatDateToString(from: now))

        newGameTableView.dataSource = self
        newGameTableView.delegate = self

        newGameViewModel?.delegate = self

        newGameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}

extension NewGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGame.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game = newGame[indexPath.row]

            cell.releaseGame.text = game.released
            cell.genreGame.text = game.genres
            cell.titleGame.text = game.name
            cell.ratingGame.text = String(format: "%.2f", game.rating)

            if let downloadedImage = game.downloadedBackgroundImage {
                cell.photoGame.image = downloadedImage
            } else if let backgroundPath = game.backgroundImage {
                newGameViewModel!.fetchBackground(for: game)
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
        self.newGame = newGameViewModel!.games
        self.newGameTableView.reloadData()
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
