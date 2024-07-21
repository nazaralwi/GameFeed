import UIKit
import Combine

class FavoritesViewController: UIViewController {
    @IBOutlet var favoriteTableView: UITableView!
    private var favorites = [FavoriteModel]()
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var emptyImage: UIImageView!
    var selectedIndex = 0
    
    var rawgUseCase: RAWGUseCase?

    var cancellables = Set<AnyCancellable>()

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
            let id = Int(favorites[selectedIndex].id ?? 0)
            detail?.gameId = id
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func loadFavorites() {
        self.rawgUseCase?.getAllFavorites()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.favoriteTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch favorites: \(error)")
                }
            }, receiveValue: { favorites in
                self.favoriteIsEmpty(state: !favorites.isEmpty)
                self.favorites = favorites
                self.favoriteTableView.reloadData()
            })
            .store(in: &cancellables)
    }

    func setupView() {
        self.favoriteTableView.contentInset.bottom = 10

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self

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

            if let backgroundPath = favorite.backgroundImage {
                print(backgroundPath)
                rawgUseCase?.downloadBackground(backgroundPath: backgroundPath)
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

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
