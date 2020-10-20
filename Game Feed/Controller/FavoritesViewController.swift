import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet var favoriteTableView: UITableView!
    private var favorites: [FavoriteModel] = []
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    var selectedIndex = 0
//    var gameList = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if !ProfileModel.stateLogin {
            let createViewController = storyboard.instantiateViewController(withIdentifier: "CreateScene") as! CreateViewController
            self.present(createViewController, animated: true, completion: nil)
        } else {
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileScene") as! MyProfileViewController
            self.present(profileViewController, animated: true, completion: nil)
        }
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
//            detail?.gameId = gameList[selectedIndex].idGame
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func loadFavorites() {
        self.favoriteProvider.getAllFavorites { (results) in
            DispatchQueue.main.async {
                self.favorites = results
                self.favoriteTableView.reloadData()
            }
        }
    }
    
    func setupView() {
        self.favoriteTableView.contentInset.bottom = 10
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
//        RAWGClient.getGameList(completion: { (games, error) in
//            if !games.isEmpty {
//                self.gameList = games
//                DispatchQueue.main.async {
//                    self.favoriteTableView.reloadData()
////                    self.activityIndicator.stopAnimating()
//                }
//                print("GameModel: \(self.gameList)")
//            } else {
////                self.errorLabel.isHidden = false
////                self.activityIndicator.stopAnimating()
//            }
//        })
        
        favoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
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
