import UIKit
import Combine

class GameViewModel {
    @Published var games: [GameUIModel] = []
    @Published var loadingIndicator: Bool = false
    @Published var gameBackground: UIImage?
    @Published var indexPathGameBackground: Int = 0
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private var rawgUseCase: RAWGUseCase

    init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    func fetchUsers() {
        self.loadingIndicator = true
        rawgUseCase.getGameList().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.loadingIndicator = false
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.loadingIndicator = false
            }
        }, receiveValue: { games in
            self.games = games
            self.loadingIndicator = false
        })
        .store(in: &cancellables)
    }

    func fetchBackground(backgroundPath: String, at row: Int) {
        rawgUseCase.downloadBackground(backgroundPath: backgroundPath)
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

                self.indexPathGameBackground = row
                self.gameBackground = image
            })
            .store(in: &cancellables)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    var gameViewModel: GameViewModel?

    var cancellables = Set<AnyCancellable>()

    var selectedIndex = 0
    var gameList = [GameUIModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        print("setupView()")
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
            detail?.gameId = gameList[selectedIndex].idGame
        }
    }

    func setupView() {
        self.gameTableView.contentInset.bottom = 10

        gameTableView.dataSource = self
        gameTableView.delegate = self

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

    private func bindViewModel() {
        gameViewModel?.$games
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.gameTableView.reloadData()
            }
            .store(in: &cancellables)

        gameViewModel?.$loadingIndicator
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingIndicator in
                if loadingIndicator {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }

            }
            .store(in: &cancellables)

        gameViewModel?.$gameBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }

                if let cell = self.gameTableView.cellForRow(at: IndexPath(row: gameViewModel!.indexPathGameBackground, section: 0)) as? GameTableViewCell {
                    cell.photoGame.image = image
                    cell.setNeedsLayout()
                    cell.photoGame.roundCorners(corners: [.topRight, .topLeft], radius: 10)
                }
            }
            .store(in: &cancellables)

        gameViewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
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
            cell.ratingGame.text = String(format: "%.2f", game.rating)

            if let backgroundPath = game.backgroundImage {
                gameViewModel!.fetchBackground(backgroundPath: backgroundPath, at: indexPath.row)
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
