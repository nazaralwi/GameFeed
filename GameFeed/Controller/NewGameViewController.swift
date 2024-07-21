import UIKit
import Combine

class NewGameViewController: UIViewController {
    @IBOutlet var newGameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    var gameMediator: GameMediator?

    var cancellables = Set<AnyCancellable>()

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

        gameMediator?.getNewGameLastMonths(
            lastMonth: Formatter.formatDateToString(
                from: oneMonthBefore ?? Date()),
            now: Formatter.formatDateToString(from: now))
            .sink(receiveCompletion: { completion in
                self.activityIndicator.stopAnimating()
                if case .failure(let error) = completion {
                    print("Failed with error: \(error)")
                    self.errorLabel.isHidden = false
                }
            }, receiveValue: { games in
                if !games.isEmpty {
                    self.newGame = games
                    self.newGameTableView.reloadData()
                } else {
                    self.errorLabel.isHidden = false
                }
            })
            .store(in: &cancellables)

        newGameTableView.dataSource = self
        newGameTableView.delegate = self

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

            if let backgroundPath = game.backgroundImage {
                gameMediator?.downloadBackground(backgroundPath: backgroundPath)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("Image download finished successfully.")
                        case .failure(let error):
                            print("Image download failed with error: \(error)")
                        }
                    }, receiveValue: { data in
                        guard let image = UIImage(data: data) else {
                            return
                        }
                        cell.photoGame.image = image
                        cell.setNeedsLayout()
                        cell.photoGame.roundCorners(corners: [.topRight, .topLeft], radius: 10)
                    })
                    .store(in: &cancellables)
            }

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
